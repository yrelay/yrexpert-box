#!/bin/bash
#!----------------------------------------------------------------------------!
#!                                                                            !
#! YRexpert : (Your Yrelay) Système Expert sous Mumps GT.M et GNU/Linux       !
#! Copyright (C) 2001-2015 by Hamid LOUAKED (HL).                             !
#!                                                                            !
#!----------------------------------------------------------------------------!

# Activer la journalisation, pour l'instance

# Assurer la présence de variables requises
if [[ -z $instance && $gtmver && $gtm_dist && $basedir ]]; then
    echo "Les variables requises ne sont pas définies (instance, gtmver, gtm_dist)"
fi

$gtm_dist/mupip set -journal="enable,on,before,file=$basedir/journals/YXP.mjl" -file $basedir/globals/YXP.dat




