#!/usr/bin/env bash
#!----------------------------------------------------------------------------!
#!                                                                            !
#! YRexpert : (Your Yrelay) Système Expert sous Mumps GT.M et GNU/Linux       !
#! Copyright (C) 2001-2015 by Hamid LOUAKED (HL).                             !
#!                                                                            !
#!----------------------------------------------------------------------------!

# Importer les fichiers /www et /node /node_modules depuis yrexpert-ewd

# Vérifier la présence des variables requises
if [[ -z $instance && $gtmver && $gtm_dist && $basedir ]]; then
    echo "Les variables requises ne sont pas définies (instance, gtmver, gtm_dist, basedir)"
fi

# Importer les fichiers /www
cp -rf $basedir/src/yrexpert-ewd/www/* $basedir/www

# Créer le lien yrexpertDemo vers ewdjs
# TODO: A supprimer
if [ -h $basedir/ewdjs/www/ewd/yrexpertDemo ]; then
    rm $basedir/ewdjs/www/ewd/yrexpertDemo
    rm $basedir/ewdjs/node_modules/yrexpertDemo.js
    rm $basedir/ewdjs/node_modules/nodeYRexpert.js
fi
ln -s $basedir/www/ewd/yrexpertDemo $basedir/ewdjs/www/ewd/yrexpertDemo
ln -s $basedir/www/node_modules/yrexpertDemo.js $basedir/ewdjs/node_modules/yrexpertDemo.js
ln -s $basedir/www/node_modules/nodeYRexpert.js $basedir/ewdjs/node_modules/nodeYRexpert.js





