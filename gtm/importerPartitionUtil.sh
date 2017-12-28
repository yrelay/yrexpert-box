#!/usr/bin/env bash
#!----------------------------------------------------------------------------!
#!                                                                            !
#! YRexpert : (Your Yrelay) Système Expert sous Mumps GT.M et GNU/Linux       !
#! Copyright (C) 2001-2015 by Hamid LOUAKED (HL).                             !
#!                                                                            !
#!----------------------------------------------------------------------------!

# Importer yrexpert-dmo Globals et Routines dans l'instance $instance

# Vérifier la présence des variables requises
if [[ -z $instance && $gtmver && $gtm_dist && $basedir && $partition ]]; then
    echo "Les variables requises ne sont pas définies (instance, gtmver, gtm_dist, basedir, partition)"
fi

# Importer les routines
#TODO : Simplifier par $partdir
echo "Copier les routines"
OLDIFS=$IFS
IFS=$'\n'
#for routine in $(cd $basedir/src/yrexpert-${partition^^} && git ls-files -- \*.m); do
for routine in $(cd $basedir/src/yrexpert-${partition} && git ls-files -- \*.m); do
#    cp $basedir/src/yrexpert-${partition^^}/${routine} $basedir/partitions/${partition,,}/routines
    cp $basedir/src/yrexpert-${partition}/${routine} $basedir/partitions/${partition,,}/routines
done
echo "Copie des routines terminée"

# Compiler les routines
echo "Compiler les routines"
cd $basedir/routines/$gtmver
for routine in $basedir/partitions/${partition,,}/routines/*.m; do
    mumps ${routine} >> $basedir/partitions/${partition,,}/log/compilerRoutines.log 2>&1
done
echo "Compilation des routines terminée"

# Import globals
echo "Importer les globals"
#for global in $(cd $basedir/src/yrexpert-${partition^^} && git ls-files -- \*.zwr); do
for global in $(cd $basedir/src/yrexpert-${partition} && git ls-files -- \*.zwr); do
#    mupip load \"$basedir/src/yrexpert-${partition^^}/${global}\" >> $basedir/partitions/${partition,,}/log/importerGloabls.log 2>&1
    mupip load \"$basedir/src/yrexpert-${partition}/${global}\" >> $basedir/partitions/${partition,,}/log/importerGloabls.log 2>&1
done
echo "Importation des globals terminée"

# reset IFS
IFS=$OLDIFS



