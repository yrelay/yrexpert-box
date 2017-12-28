#!/usr/bin/env bash
#!----------------------------------------------------------------------------!
#!                                                                            !
#! YRexpert : (Your Yrelay) Système Expert sous Mumps GT.M et GNU/Linux       !
#! Copyright (C) 2001-2015 by Hamid LOUAKED (HL).                             !
#!                                                                            !
#!----------------------------------------------------------------------------!

# Supprimer des répertoires par exemple Routines, Objects, Globals, Journals,
# Temp Files

# Options
# instance = nom de l'instance
# Utilisation http://rsalveti.wordpress.com/2007/04/03/bash-parsing-arguments-with-getopts/
# Documentation à titre indicatif

usage()
{
    cat << EOF
    usage: $0 options

    Ce script va supprimer une instance YRexpert pour GT.M

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

# Assurez-vous que nous sommes dans le groupe, nous devons être capable
# de modifier l'instance
if [[ $USER -ne $instance && $basedir && $gtm_dist && $instance ]]; then
    echo "Ce script doit être exécuté en tant que $instance et avoir défini les variables suivantes :
    \$basedir
    \$instance
    \$gtm_dist" 1>&2
    exit 1
fi

echo "Suppression de $instance..."

# Fermer correctement l'instance YRexpert
processes=$(pgrep mumps)
if [ ! -z "${processes}" ] ; then
    echo "Arrêt des processus M restants"
    for i in ${processes}
    do
        mupip stop ${i}
    done

    # Attendre que le processus réagisse à mupip, pour éviter de forcer
    # la fermeture plus tard
    sleep 5
fi

# Rechercher les processus M qui sont encore en cours d'exécution
processes=$(pgrep mumps)
if [ ! -z "${processes}" ] ; then
    echo "Les processus en cours suivant seront fermer de force !"
    pkill -9 mumps
fi

# Supprimer les répartoires de l'instance
rm -f $basedir/routines/*.m
rm -f $basedir/routines/$gtmver/*.o
rm -f $basedir/globals/*.dat
rm -f $basedir/journals/*.mjl

# Recréer les bases de données
$gtm_dist/mupip create

echo "Suppression de l'instance $instance terminée"



