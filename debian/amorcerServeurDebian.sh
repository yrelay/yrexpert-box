#!/usr/bin/env bash
#!----------------------------------------------------------------------------!
#!                                                                            !
#! YRexpert : (Your Yrelay) Système Expert sous Mumps GT.M et GNU/Linux       !
#! Copyright (C) 2001-2015 by Hamid LOUAKED (HL).                             !
#!                                                                            !
#!----------------------------------------------------------------------------!

# Assurez-vous que nous sommes en root
if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être exécuté en tant que root" 1>&2
    exit 1
fi

# Mettre à jour le serveur avec les dépôts
apt-get -y -qq update > /dev/null
apt-get -y -qq upgrade > /dev/null

# Installer les paquets de base
#apt-get install -y -qq git xinetd perl wget curl python ssh mysql-server openjdk-7-jdk maven sshpass > /dev/null
#apt-get install -y -qq git xinetd perl wget curl python ssh mysql-server maven sshpass libicu-dev > /dev/null // n'existe plus sur Debian Buster
apt-get install -y -qq git xinetd perl wget curl python ssh maven sshpass libicu-dev apt-utils > /dev/null
