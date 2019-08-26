#!/usr/bin/env bash
#!----------------------------------------------------------------------------!
#!                                                                            !
#! YRexpert : (Your Yrelay) Système Expert sous Mumps GT.M et GNU/Linux       !
#! Copyright (C) 2001-2015 by Hamid LOUAKED (HL).                             !
#!                                                                            !
#!----------------------------------------------------------------------------!

# Créer les répertoires pour les routines, les objets, les globals,
# les Journaux, les fichiers temporaires de l'instance
# Cet utilitaire nécessite privliges root

# Assurez-vous que nous sommes en root
if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être exécuté en tant que root" 1>&2
    exit 1
fi

# Si chkconfig n'est pas installé
# TODO: à modifier
#apt-get install chkconfig

# Si icu-config n'est pas installé
apt-get install -y libicu-dev

# Options
# Utilisation http://rsalveti.wordpress.com/2007/04/03/bash-parsing-arguments-with-getopts/
# Documentation à titre indicatif

usage()
{
    cat << EOF
    usage: $0 options

    Ce script permet de créer une instance de YRexpert pour GT.M

    OPTIONS:
      -h    Afficher ce message
      -i    Nom de l'instance
EOF
}

while getopts ":hi:" option
do
    case $option in
        h)
            usage
            exit 1
            ;;
        i)
            instance=$(echo $OPTARG |tr '[:upper:]' '[:lower:]')
            ;;
    esac
done

if [[ -z $instance ]]
then
    usage
    exit 1
fi

# Déterminer l'architecture du processeur - utilisé pour déterminer si nous pouvons utiliser GT.M
arch=$(uname -m | tr -d _)
if [ $arch == "x8664" ]; then
    gtm_arch="x86_64"
else
    gtm_arch="i386"
fi

# Créer la configuration par défaut de la base de données standard
dirs=$(find /usr/lib/fis-gtm -maxdepth 1 -type d -printf '%P\n')

# Rechercher GT.M:
# Utiliser le chemin /usr/lib/{gtm_arch}-linux-gnu/fis-gtm
# nous pouvons lister les répertoires si > 1 erreur de répertoire
# Par défaut GT.M est installé sur /usr/lib/fis-gtm/{gtm_ver}
# quand gtm_arch=(i386 | x86_64) pour linux

#gtm_dirs=$(ls -1 /usr/lib/fis-gtm | wc -l | sed 's/^[ \t]*//;s/[ \t]*$//')
#if [ $gtm_dirs -gt 2 ]; then
#    echo "Plus d'une version de GT.M installé !"
#    echo "Impossible de déterminer quelle version de GT.M à utiliser !"
#    exit 2
#fi

# Un seul version GT.M trouvée
gtmver=$(ls -1 /usr/lib/fis-gtm | tail -1)
gtm_dist=/usr/lib/fis-gtm/$gtmver

# $basedir est le répertoire de base de l'instance
# exemples d'installation possibles : /home/$instance, /opt/$instance, /var/db/$instance
basedir=/home/$instance

# Supprimer l'instance $instance s'il semble qu'elle existe déjà.
if grep "^$instance:" /etc/passwd > /dev/null ||
   grep "^${instance}util:" /etc/passwd > /dev/null ||
   grep "^${instance}prog:" /etc/passwd > /dev/null ; then
    # TODO: A compléter supprimerInstanceYRexpertTotale.sh et supprimer les lignes ci-dessous
    su $instance -c "source $basedir/config/env && $basedir/scripts/supprimerInstanceYRexpertMinimale.sh -i $instance"
fi

# Créer $instance User/Group
# $instance user est un user administrateur
# $instance group permet les autorisations à d'autres utilisateurs
# $instance group est automatiquement créé par le script adduser
useradd -c "Propriétaire de l'instance $instance" -m -U $instance -s /bin/bash
useradd -c "Compte utilisateur de l'instance $instance" -M -N -g $instance -s /home/$instance/scripts/util.sh -d /home/$instance ${instance}util
useradd -c "Compte programmeur de l'instance $instance" -M -N -g $instance -s /home/$instance/scripts/prog.sh -d /home/$instance ${instance}prog

# Changer le mot de passe pour les comptes liés
echo ${instance}:${instance} | chpasswd
echo ${instance}util:util | chpasswd
echo ${instance}prog:prog | chpasswd

# Créer les répertoires de l'instance
su $instance -c "mkdir -p $basedir/{routines,routines/$gtmver,globals,journals,config,config/xinetd.d,log,tmp,scripts,libraries,backup,partitions,src}"

# Créer un lien symbolique vers le chemin de l'instance $instance
ln -s $basedir $basedir/partitions/yxp

# Copier les répertoires standards config et scripts du dépot
su $instance -c "cp -R config $basedir"
su $instance -c "cp -R scripts $basedir"

# Mofifier les répertoires xinetd.d et scripts pour qu'ils reflètent l'instance $instance
# TODO: Voir l'utilité de xinetd.d
perl -pi -e 's/y-instance/'$instance'/g' $basedir/scripts/*.sh
#--- perl -pi -e 's/y-instance/'$instance'/g' $basedir/config/xinetd.d/yrexpert-*

# Modify init.d script to reflect $instance
perl -pi -e 's/y-instance/'$instance'/g' $basedir/config/init.d/yrexpert

# Créer le démmarrage du service
# TODO: Faire fonctionner avec un lien -h
if [ -f /etc/init.d/${instance}yrexpert ]; then
    rm /etc/init.d/${instance}yrexpert
fi
#ln -s $basedir/config/init.d/yrexpert /etc/init.d/${instance}yrexpert
cp $basedir/config/init.d/yrexpert /etc/init.d/${instance}yrexpert

# Installer le script init
if [[ $debian || -z $RHEL ]]; then
    update-rc.d ${instance}yrexpert defaults 80 20
fi

if [[ $RHEL || -z $debian ]]; then
    # TODO: à modifier
    #chkconfig --add ${instance}yrexpert
    echo "voir TODO..."
fi

# Lien symbolique pour GT.M
su $instance -c "ln -s $gtm_dist/utf8 $basedir/libraries/gtm"

# Créer le profile de l'instance
# Necessite les variables GT.M
# TODO: Vérifier 'I \$\$JOBEXAM^ZU(\$ZPOSITION)'
echo "export gtm_dist=$basedir/libraries/gtm"	>> $basedir/config/env
echo "export gtm_log=$basedir/log"              >> $basedir/config/env
echo "export gtm_tmp=$basedir/tmp"              >> $basedir/config/env
echo "export gtm_prompt=\"YXP>\""     		>> $basedir/config/env
echo "export gtmgbldir=$basedir/partitions/yxp/globals/YXP.gld"	>> $basedir/config/env
echo "export gtm_zinterrupt='I \$\$JOBEXAM^ZU(\$ZPOSITION)'" 	>> $basedir/config/env
echo "export gtm_lvnullsubs=2"                  >> $basedir/config/env
echo "export PATH=\$PATH:\$gtm_dist"            >> $basedir/config/env
echo "export basedir=$basedir"                  >> $basedir/config/env
echo "export gtm_arch=$gtm_arch"                >> $basedir/config/env
echo "export gtmver=$gtmver"                    >> $basedir/config/env
echo "export instance=$instance"                >> $basedir/config/env

# echo "export gtm_icu_version=`icu-config --version`"		>> $basedir/config/env // n'existe pas Debian Buster
echo "export gtm_icu_version=`uconv --version | cut -d' ' -f5`"	>> $basedir/config/env
echo "export gtm_chset=UTF-8"			>> $basedir/config/env
#echo "export LC_CTYPE=fr_FR.utf8"		>> $basedir/config/env

# Mettre les droits corrects pour env
chown $instance:$instance $basedir/config/env

# Envrionment source en shell bash
grep "source $basedir/config/env" $basedir/.bashrc
if [ "$?" = 0 ]; then
    # si la ligne existe dans .bashrc - ne rien faire
    echo "La ligne existe dans .bashrc, ne rien faire..."
else
    # si la ligne n'existe pas
    echo "source $basedir/config/env" >> $basedir/.bashrc
fi

# Configurer la variable gtmroutines
gtmroutines="\$basedir/routines/\$gtmver(\$basedir/routines)"

# GT.M 64bit peut utiliser une bibliothèque partagée au lieu de $gtm_dist
if [ $gtm_arch == "x86_64" ]; then
    echo "export gtmroutines=\"$gtmroutines $basedir/libraries/gtm/libgtmutil.so $basedir/libraries/gtm\"" >> $basedir/config/env
else
    echo "export gtmroutines=\"$gtmroutines $basedir/libraries/gtm\"" >> $basedir/config/env
fi

# prog.sh - accès des utilisateurs privilégiés (programmeur)
# Autoriser l'accès à ZSY
echo "#!/bin/bash"                              >> $basedir/scripts/prog.sh
echo "source $basedir/config/env"               >> $basedir/scripts/prog.sh
echo "export SHELL=/bin/bash"               	>> $basedir/scripts/prog.sh
echo "#Cela existent pour des raisons de compatibilité"   >> $basedir/scripts/prog.sh
echo "alias gtm=\"\$gtm_dist/mumps -dir\""      >> $basedir/scripts/prog.sh
echo "alias GTM=\"\$gtm_dist/mumps -dir\""      >> $basedir/scripts/prog.sh
echo "alias gde=\"\$gtm_dist/mumps -run GDE\""  >> $basedir/scripts/prog.sh
echo "alias lke=\"\$gtm_dist/mumps -run LKE\""  >> $basedir/scripts/prog.sh
echo "alias dse=\"\$gtm_dist/mumps -run DSE\""  >> $basedir/scripts/prog.sh
echo "\$gtm_dist/mumps -dir"                    >> $basedir/scripts/prog.sh

# Mettre les droits corrects pour prog.sh
chown $instance:$instance $basedir/scripts/prog.sh
chmod +x $basedir/scripts/prog.sh

# util.sh - accès des utilisateurs non-privilégiés
# $instance est leur environnent - pas d'accès à ZSY
# besoin de mettre les utilisateurs $basedir/config/util.sh dans leur environnement
echo "#!/bin/bash"                              >> $basedir/scripts/util.sh
echo "source $basedir/config/env"		>> $basedir/scripts/util.sh
echo "export SHELL=/scripts/false"              >> $basedir/scripts/util.sh
echo "export gtm_nocenable=true"                >> $basedir/scripts/util.sh
echo "exec \$gtm_dist/mumps -run ^VSTART"       >> $basedir/scripts/util.sh

# Mettre les droits corrects pour util.sh
chown $instance:$instance $basedir/scripts/util.sh
chmod +x $basedir/scripts/util.sh

# Créer les globals
echo "c -s DEFAULT    -ACCESS_METHOD=BG -BLOCK_SIZE=4096 -ALLOCATION=200000 -EXTENSION_COUNT=1024 -GLOBAL_BUFFER_COUNT=4096 -LOCK_SPACE=400 -FILE=$basedir/globals/YXP.dat" >> $basedir/config/db.gde
echo "a -s TEMP       -ACCESS_METHOD=MM -BLOCK_SIZE=4096 -ALLOCATION=10000 -EXTENSION_COUNT=1024 -GLOBAL_BUFFER_COUNT=4096 -LOCK_SPACE=400 -FILE=$basedir/globals/temp.dat" >> $basedir/config/db.gde
echo "c -r DEFAULT    -RECORD_SIZE=16368 -KEY_SIZE=1019 -JOURNAL=(BEFORE_IMAGE,FILE_NAME=\"$basedir/journals/YXP.mjl\") -DYNAMIC_SEGMENT=DEFAULT" >> $basedir/config/db.gde
echo "a -r TEMP       -RECORD_SIZE=16368 -KEY_SIZE=1019 -NOJOURNAL -DYNAMIC_SEGMENT=TEMP"   >> $basedir/config/db.gde
echo "a -n TMP        -r=TEMP"                  >> $basedir/config/db.gde
echo "a -n TEMP       -r=TEMP"                  >> $basedir/config/db.gde
echo "a -n UTILITY    -r=TEMP"                  >> $basedir/config/db.gde
echo "a -n XTMP       -r=TEMP"                  >> $basedir/config/db.gde
echo "a -n CacheTemp* -r=TEMP"                  >> $basedir/config/db.gde
echo "sh -a"                                    >> $basedir/config/db.gde

# Mettre les droits corrects pour db.gde
chown $instance:$instance $basedir/config/db.gde

# Créer db.gde
su $instance -c "source $basedir/config/env && \$gtm_dist/mumps -run GDE < $basedir/config/db.gde > $basedir/log/sortieGDE.log 2>&1"

# Créer la base de données
echo "Créer la base de données"
su $instance -c "source $basedir/config/env && \$gtm_dist/mupip create > $basedir/log/creerDatabase.log 2>&1"
echo "Création de la base de données terminée"

# Mettre les droits
chown -R $instance:$instance $basedir
chmod -R g+rw $basedir

# Ajouter les règles pour le firewall
if [[ $RHEL || -z $debian ]]; then
    iptables -I INPUT 1 -p tcp --dport 8001 -j ACCEPT # Pour une future connexion
    service iptables save
fi

echo "L'instance d'YRexpert $instance est créée..."



