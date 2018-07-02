#!/usr/bin/env bash
#!----------------------------------------------------------------------------!
#!                                                                            !
#! Yexpert : (your) Système Expert sous Mumps GT.M et GNU/Linux               !
#! Copyright (C) 2001-2015 by Hamid LOUAKED (HL).                             !
#!                                                                            !
#!----------------------------------------------------------------------------!

# Supprimer totalement l'instance de YRexpert 
# Cet utilitaire nécessite privliges root

# Assurez-vous que nous sommes en root
if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être exécuté en tant que root" 1>&2
    exit 1
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

    Ce script permet de supprimer une instance de YRexpert pour GT.M

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

# $basedir est le répertoire de base de l'instance
# exemples d'installation possibles : /home/$instance, /opt/$instance, /var/db/$instance
basedir=/home/$instance

# Arrêter le service
if [[ $debian || -z $RHEL ]]; then
    update-rc.d ${instance}yrexpert remove
    update-rc.d ${instance}yrexpert-js remove
fi

if [[ $RHEL || -z $debian ]]; then
    #TODO: à modifer
    #chkconfig --del ${instance}yrexpert
    #chkconfig --del ${instance}yrexpert-js
    echo "voir TODO..."
fi

# Arrêter et supprimer les services
if [ -h /etc/init.d/${instance}yrexpert ]; then
    service ${instance}yrexpert stop
    rm /etc/init.d/${instance}yrexpert
fi

if [ -h /etc/init.d/${instance}yrexpert-js ]; then
    service ${instance}yrexpert-js stop
    rm /etc/init.d/${instance}yrexpert-js
fi

# Supprimer l'instance $instance s'il semble qu'elle existe déjà.
if grep "^$instance:" /etc/passwd > /dev/null ||
   grep "^${instance}util:" /etc/passwd > /dev/null ||
   grep "^${instance}prog:" /etc/passwd > /dev/null ; then
    deluser --remove-home ${instance}util
    deluser --remove-home ${instance}prog
    deluser --remove-home ${instance}
    delgroup ${instance}util
    delgroup ${instance}prog
    delgroup ${instance}
fi

echo "L'instance d'YRexpert $instance est supprimée..."



