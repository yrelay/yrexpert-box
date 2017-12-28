#!/usr/bin/env bash
#!----------------------------------------------------------------------------!
#!                                                                            !
#! YRexpert : (Your Yrelay) Système Expert sous Mumps GT.M et GNU/Linux       !
#! Copyright (C) 2001-2015 by Hamid LOUAKED (HL).                             !
#!                                                                            !
#!----------------------------------------------------------------------------!

# Installez GT.M en utilisant un script de gtminstall
# Cet utilitaire nécessite des privliges root

# Assurez-vous que nous sommes en root
if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être exécuté en tant que root" 1>&2
    exit 1
fi

echo "Création de $instance..."

# Installer GT.M
apt-get install -y fis-gtm

# Déterminer l'architecture du processeur - utilisé pour déterminer si nous pouvons utiliser GT.M
arch=$(uname -m | tr -d _)
if [ $arch == "x8664" ]; then
    gtm_arch="x86_64"
else
    gtm_arch="i386"
fi

# Rechercher GT.M:
# Utiliser le chemin /usr/lib/{gtm_arch}-linux-gnu/fis-gtm
# nous pouvons lister les répertoires si > 1 erreur de répertoire
# Par défaut GT.M est installé sur /usr/lib/{gtm_arch}-linux-gnu/fis-gtm/{gtm_ver}
# quand gtm_arch=(i386 | x86_64) pour linux

gtm_dirs=$(ls -1 /usr/lib/${gtm_arch}-linux-gnu/fis-gtm | wc -l | sed 's/^[ \t]*//;s/[ \t]*$//')
if [ $gtm_dirs -gt 1 ]; then
    echo "Plus d'une version de GT.M installé!"
    echo "Impossible de déterminer quelle version de GT.M à utiliser"
    exit 1
fi

# Un seul version GT.M trouvée
gtm_dist=/usr/lib/${gtm_arch}-linux-gnu/fis-gtm/$(ls -1 /usr/lib/${gtm_arch}-linux-gnu/fis-gtm)
gtm_ver=$(ls -1 /usr/lib/${gtm_arch}-linux-gnu/fis-gtm)

# Lier la bibliothèque partagée GT.M  et rafraîchir la mémoire cache
if [[ $rhel || -z $debian ]]; then
    # TODO: Vérifier le chemin /usr/local/lib
    echo "/usr/local/lib" >> /etc/ld.so.conf
fi
# TODO: A supprimer
if [ -h /usr/lib/$gtm_arch-linux-gnu/libgtmshr.so ]; then
    rm /usr/lib/$gtm_arch-linux-gnu/libgtmshr.so
fi
ln -s /usr/lib/$gtm_arch-linux-gnu/fis-gtm/$gtm_ver/libgtmshr.so /usr/lib/$gtm_arch-linux-gnu/libgtmshr.so
ldconfig

echo "Installation de GT.M terminée..."



