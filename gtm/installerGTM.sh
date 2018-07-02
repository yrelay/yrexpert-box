#!/usr/bin/env bash
#!----------------------------------------------------------------------------!
#!                                                                            !
#! YRexpert : (Your Yrelay) Système Expert sous Mumps GT.M et GNU/Linux       !
#! Copyright (C) 2001-2015 by Hamid LOUAKED (HL).                             !
#!                                                                            !
#!----------------------------------------------------------------------------!

# Installez GT.M en utilisant un script
# Cet utilitaire nécessite des privliges root

# Assurez-vous que nous sommes en root
if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être exécuté en tant que root" 1>&2
    exit 1
fi

# Preparation
echo "Preparer l'environment"
sudo apt-get update
sudo apt-get install -y build-essential libssl-dev
sudo apt-get install -y wget gzip openssh-server curl python-minimal libelf1

# Si icu-config n'est pas installé
apt-get install -y libicu-dev

# GT.M
echo 'Installer GT.M'

mkdir /tmp/tmp # Créer un répertoire temporaire pour le programme d'installation
cd /tmp/tmp    # Se déplacer sur le répertoire temporaire
wget https://sourceforge.net/projects/fis-gtm/files/GT.M%20Installer/v0.13/gtminstall #  Télécharger le programme d'installation GT.M
chmod +x gtminstall # Rendre le fichier exécutable

# définir variables
gtmroot=/usr/lib/fis-gtm
gtmcurrent=$gtmroot/current
if [ -e "$gtmcurrent"] ; then
  mv -v $gtmcurrent $gtmroot/previous_`date -u +%Y-%m-%d:%H:%M:%S`
fi
sudo mkdir -p $gtmcurrent # S'assurer que le répertoire existe pour les liens vers GT.M actuel
sudo -E ./gtminstall --overwrite-existing --utf8 `icu-config --version` --verbose --linkenv $gtmcurrent --linkexec $gtmcurrent # télécharger et installer GT.M, y compris UTF-8 mode

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
echo 'copier ' $gtmprofcmd ' vers profile...'
echo $gtmprofcmd >> ~/.profile
# TODO: fin de la réparation temporaire

rm $tmpfile
unset tmpfile gtmprofcmd gtmprof gtmcurrent gtmroot

echo "GT.M a été installé et configuré, prêt à l'emploi"
echo 'Entrez dans le shell GT.M en tapant la commande : gtm'
echo 'Sortir en tapant la commande : H'


