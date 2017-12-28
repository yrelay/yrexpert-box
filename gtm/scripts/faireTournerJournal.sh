#!/usr/bin/env bash
#!----------------------------------------------------------------------------!
#!                                                                            !
#! YRexpert : (Your Yrelay) Système Expert sous Mumps GT.M et GNU/Linux       !
#! Copyright (C) 2001-2015 by Hamid LOUAKED (HL).                             !
#!                                                                            !
#!----------------------------------------------------------------------------!

# Faire tourner le journal pour l'instance

# Assurer la présence de variables requises
if [[ -z $instance && $gtmver && $gtm_dist && $basedir ]]; then
    echo "Les variables requises ne sont pas définies (instance, gtmver, gtm_dist)"
fi

# Variable pour déterminer le nombre de jours à garder pur le journal
daystokeep="5"

# Supprimer les journaux âgés de plus de $daystokeep
find $basedir/j/ -name "*.mjl_*" -type f -ctime +$daystokeep -exec rm -v {} >> $basedir/log/supprimerJournal.log \;



