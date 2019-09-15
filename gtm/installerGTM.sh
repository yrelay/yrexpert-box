#!/usr/bin/env bash
#!----------------------------------------------------------------------------!
#!                                                                            !
#! YRexpert : (Your Yrelay) Système Expert sous Mumps GT.M et GNU/Linux       !
#! Copyright (C) 2001-2015 by Hamid LOUAKED (HL).                             !
#!                                                                            !
#!----------------------------------------------------------------------------!

# Installez GT.M en utilisant un script
# Cet utilitaire nécessite des privliges root

echo 'installGTM.sh-------------------------------------------------------------------'

# Assurez-vous que nous sommes en root
if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être exécuté en tant que root" 1>&2
    exit 1
fi

# Assurez-vous qu'il que GT.M n'est pas installé
if [ -d "/usr/lib/fis-gtm" ]; then
  echo "GT.M semble avoir déjà été installé - abandon"
  exit 0
fi

# Preparation

echo "Preparer l'environment"

sudo apt-get update
sudo apt-get install -y build-essential libssl-dev
sudo apt-get install -y wget gzip openssh-server curl python-minimal libelf1 libncurses5

# GT.M

echo 'Installer GT.M'

# V014B******************************************************************
# # Si existe supprimer le répertoire temporaire
# if [ -d /tmp/gtminstall ] ; then
#   sudo rm -rf /tmp/gtminstall
# fi
# mkdir /tmp/gtminstall # Créer un répertoire temporaire pour le programme d'installation
# cd /tmp/gtminstall    # Se déplacer sur le répertoire temporaire
# wget https://sourceforge.net/projects/fis-gtm/files/GT.M%20Installer/v0.14/gtminstall #  Télécharger le programme d'installation GT.M
# chmod +x gtminstall # Rendre le fichier exécutable
# V014B******************************************************************

# Définir variables
gtmroot=/usr/lib/fis-gtm
gtmcurrent=$gtmroot/current
if [ -e $gtmcurrent ] ; then
  mv -v $gtmcurrent $gtmroot/previous_`date -u +%Y-%m-%d:%H:%M:%S`
fi

# S'assurer que le répertoire existe pour les liens vers GT.M actuel
sudo mkdir -p $gtmcurrent

# Télécharger et installer GT.M, y compris UTF-8 mode
# sudo -E ./gtminstall --overwrite-existing --utf8 default --verbose --linkenv $gtmcurrent --linkexec $gtmcurrent > /dev/null
sudo -E ./gtminstall --overwrite-existing --utf8 default --verbose --linkenv $gtmcurrent --linkexec $gtmcurrent

echo 'Configurer GT.M'

gtmprof=$gtmcurrent/gtmprofile
gtmprofcmd="source $gtmprof"
$gtmprofcmd
tmpfile=`mktemp`
if [ `grep -v "$gtmprofcmd" ~/.profile | grep $gtmroot >$tmpfile`] ; then
  echo "Attention : références de commandes existantes $gtmroot dans ~/.profile peut interférer avec la configuration de l'environnement"
  cat $tmpfile
fi

# TODO: Correctif temporaire pour s'assurer que l'invocation de gtmprofile est correctement ajoutée à .profile
##echo 'copier ' $gtmprofcmd ' vers profile...'
##echo $gtmprofcmd >> ~/.profile
# TODO: fin de la réparation temporaire

rm $tmpfile
unset tmpfile gtmprofcmd gtmprof gtmcurrent gtmroot

echo "GT.M a été installé et configuré, prêt à l'emploi"
echo 'Entrez dans le shell GT.M en tapant la commande : gtm'
echo 'Sortir en tapant la commande : H'

echo 'installGTM.sh-------------------------------------------------------------------'
