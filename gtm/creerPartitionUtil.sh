#!/usr/bin/env bash
#!----------------------------------------------------------------------------!
#!                                                                            !
#! YRexpert : (Your Yrelay) Système Expert sous Mumps GT.M et GNU/Linux       !
#! Copyright (C) 2001-2015 by Hamid LOUAKED (HL).                             !
#!                                                                            !
#!----------------------------------------------------------------------------!

# Créer les répertoires pour les routines, les objets, les globals,
# les Journaux, les fichiers temporaires de la partition $partition
# Cet utilitaire nécessite privliges root

# Assurez-vous que nous sommes en root
if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être exécuté en tant que root" 1>&2
    exit 1
fi

# Vérifier la présence des variables requises
if [[ -z $instance && $gtmver && $gtm_dist ]]; then
    echo "Les variables requises ne sont pas définies (instance, gtmver, gtm_dist)"
fi

# Si chkconfig n'est pas installé
# TODO: à modifier
#apt-get install chkconfig

# Options
# Utilisation http://rsalveti.wordpress.com/2007/04/03/bash-parsing-arguments-with-getopts/
# Documentation à titre indicatif

usage()
{
    cat << EOF
    usage: $0 options

    Ce script permet de créer une partititon DMO pour YRexpert

    OPTIONS:
      -h    Afficher ce message
      -i    Nom de la partition
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
            partition=$(echo $OPTARG |tr '[:upper:]' '[:lower:]')
            partdir=$basedir/partitions/$partition

            ;;
    esac
done

if [[ -z $partition ]]
then
    usage
    exit 1
fi

# Créer les répertoires de l'instance
su $instance -c "mkdir -p $partdir/{routines,routines/$gtmver,globals,journals,config,log,tmp,scripts,backup}"

# Copier les répertoires standards du dépot yrexpert-dmo
su $instance -c "cp -R $basedir/src/yrexpert-dmo/scripts $partdir"

# Créer le profile de la partition
# Necessite les variables GT.M
echo "export gtm_dist=$basedir/libraries/gtm"   >> $partdir/config/env
echo "export gtm_log=$partdir/log" 		>> $partdir/config/env
echo "export gtm_tmp=$partdir/tmp" 		>> $partdir/config/env
echo "export gtm_prompt=\"${partition^^}>\""    >> $partdir/config/env
echo "export gtmgbldir=$partdir/globals/${partition^^}.gld" 	>> $partdir/config/env
echo "export gtm_zinterrupt='I \$\$JOBEXAM^ZU(\$ZPOSITION)'" 	>> $partdir/config/env
echo "export gtm_lvnullsubs=2"                  >> $partdir/config/env
echo "export PATH=\$PATH:\$gtm_dist"            >> $partdir/config/env
echo "export basedir=$basedir"                  >> $partdir/config/env
echo "export gtm_arch=$gtm_arch"                >> $partdir/config/env
echo "export gtmver=$gtmver"                    >> $partdir/config/env
echo "export instance=$instance"                >> $partdir/config/env
echo "export partition=$partition"              >> $partdir/config/env

echo "export gtm_icu_version=`icu-config --version`"		>> $partdir/config/env
echo "export gtm_chset=UTF-8"			>> $partdir/config/env
#echo "export LC_CTYPE=fr_FR.utf8"		>> $basedir/config/env

# Mettre les droits corrects pour env
chown $instance:$instance $partdir/config/env

# Mettre les droits corrects pour $partdir
chown $instance:$instance $partdir

# Créer les globals DMO
# TODO: Introduire la notion de version de gtm
echo "c -s DEFAULT    -ACCESS_METHOD=BG -BLOCK_SIZE=4096 -ALLOCATION=200000 -EXTENSION_COUNT=1024 -GLOBAL_BUFFER_COUNT=4096 -LOCK_SPACE=400 -FILE=$partdir/globals/${partition^^}.dat" >> $partdir/config/db.gde
echo "a -s TEMP       -ACCESS_METHOD=MM -BLOCK_SIZE=4096 -ALLOCATION=10000 -EXTENSION_COUNT=1024 -GLOBAL_BUFFER_COUNT=4096 -LOCK_SPACE=400 -FILE=$partdir/globals/temp.dat" >> $partdir/config/db.gde
echo "c -r DEFAULT    -RECORD_SIZE=16368 -KEY_SIZE=1019 -JOURNAL=(BEFORE_IMAGE,FILE_NAME=\"$partdir/journals/${partition^^}.mjl\") -DYNAMIC_SEGMENT=DEFAULT" >> $partdir/config/db.gde
echo "a -r TEMP       -RECORD_SIZE=16368 -KEY_SIZE=1019 -NOJOURNAL -DYNAMIC_SEGMENT=TEMP"   >> $partdir/config/db.gde
echo "a -n TMP        -r=TEMP"                  >> $partdir/config/db.gde
echo "a -n TEMP       -r=TEMP"                  >> $partdir/config/db.gde
echo "a -n UTILITY    -r=TEMP"                  >> $partdir/config/db.gde
echo "a -n XTMP       -r=TEMP"                  >> $partdir/config/db.gde
echo "a -n CacheTemp* -r=TEMP"                  >> $partdir/config/db.gde
echo "sh -a"                                    >> $partdir/config/db.gde

# Mettre les droits corrects pour db.gde
chown $instance:$instance $partdir/config/db.gde

# Créer db.gde
su $instance -c "source $partdir/config/env && \$gtm_dist/mumps -run GDE < $partdir/config/db.gde > $partdir/log/sortieGDE.log 2>&1"

# Créer la base de données
echo "Créer la base de données"
su $instance -c "source $partdir/config/env && \$gtm_dist/mupip create > $partdir/log/creerDatabase.log 2>&1"
echo "Création de la base de données terminée"

# Mettre les droits
chown -R $instance:$instance $partdir
chmod -R g+rw $partdir

echo "La partition DMO d'YRexpert de l'instance $instance est créée..."



