#!/bin/bash
#!----------------------------------------------------------------------------!
#!                                                                            !
#! YRexpert : (Your Relay) Système Expert sous Mumps GT.M et GNU/Linux        !
#! Copyright (C) 2001-2015 by Hamid LOUAKED (HL).                             !
#!                                                                            !
#!----------------------------------------------------------------------------!

# test > /home/hamid/yrelay/yrexpert-box/gtm/scripts/reparerGlobalsYXP.sh

# Réparer le fichier conteneur de DMO. Si la base de données est endommagée,
# vous aurez le message suivant : %GTM-E-REQRUNDOWN, Error accessing database
echo "{--- Début du script **reparerGlobalsYXP.sh**"

###
# Récuperer les répertoires d'installation yxp et gtm
export yxp_dist=/home/yrelay
echo "yxp_dist="$yxp_dist
source $yxp_dist/config/env

###
# Définir les variable d'environnement de GTM
export gtmgbldir="$yxp_dist/partitions/yxp/globals/YXP.gld"

echo ""
echo "Réparer la base de données. Ceci peut prendre un moment..."
echo ""
echo $yxp_dist
echo $gtm_dist
echo $gtmgbldir
echo ""

# Réparer les globales pour la base de données
$gtm_dist/mupip rundown -FILE $yxp_dist/partitions/yxp/globals/YXP.dat
$gtm_dist/mupip rundown -region "*" # Pour réactiver les database
$gtm_dist/mupip integ -region "*" # Si besoin, pour réparer les erreurs dans votre database
# Si les erreurs ne sont pas réparées voir le chapitre DSE dans la documentation admin  



echo "---}Fin du script **reparerGlobalsYXP.sh**"

