#!/usr/bin/env bash
#!----------------------------------------------------------------------------!
#!                                                                            !
#! YRexpert : (Your Yrelay) Système Expert sous Mumps GT.M et GNU/Linux       !
#! Copyright (C) 2001-2015 by Hamid LOUAKED (HL).                             !
#!                                                                            !
#!----------------------------------------------------------------------------!

# Script d'installation de yrexpert-js, EWD.js et autres modules nodejs

# Vérifier la présence des variables requises
if [[ -z $instance && $gtmver && $gtm_dist && $basedir ]]; then
    echo "Les variables requises ne sont pas définies (instance, gtmver, gtm_dist)"
fi

# Définir la version de node
nodever="8" #version LST

# Définir la variable arch
arch=$(uname -m | tr -d _)

# Exécuter en tant que propriétaire de l'instance
if [[ -z $basedir ]]; then
    echo "La variable requise \$instance n'existe pas"
fi

echo "Installer yrexpert-js"

# Copier les scripts init.d dans le répertoite scripts de yrexpert
su $instance -c "cp -R config $basedir"

# Aller à $basedir
cd $basedir

# Installer node.js en utilisant NVM (node version manager) - https://github.com/creationix/nvm
echo "Télécharger et installer NVM"
su $instance -c "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash"
echo "Installation de NVM terminé"

# Installer node $nodever
su $instance -c "source $basedir/.nvm/nvm.sh && nvm install $nodever > /dev/null 2>&1 && nvm alias default $nodever && nvm use default"

# Dire à $basedir/config/env notre nodever
echo "export nodever=$nodever" >> $basedir/config/env

# Dire à nvm d'utiliser la version de node dans .profile et .bash_profile
if [ -s $basedir/.profile ]; then
    echo "" >> $basedir/.profile
    echo "source \$HOME/.nvm/nvm.sh" >> $basedir/.profile
    echo "nvm use $nodever" >> $basedir/.profile
    ###source $basedir/.nvm/nvm.sh && nvm use $nodever && echo "export PATH=`npm config get prefix`/bin:\$PATH" >> $basedir/.profile
    echo "export PATH=\`npm config get prefix\`/bin:\$PATH" >> $basedir/.profile
fi

if [ -s $basedir/.bash_profile ]; then
    echo "" >> $basedir/.bash_profile
    echo "source \$HOME/.nvm/nvm.sh" >> $basedir/.bash_profile
    echo "nvm use $nodever" >> $basedir/.bash_profile
    ###source $basedir/.nvm/nvm.sh && nvm use $nodever && echo "export PATH=`npm config get prefix`/bin:\$PATH" >> $basedir/.bash_profile
    echo "export PATH=\`npm config get prefix\`/bin:\$PATH" >> $basedir/.bash_profile
fi

# Créer les répertoires pour node
su $instance -c "source $basedir/config/env && mkdir $basedir/nodejs"

# Créer un script d'installation silencieux pour yrexpert-js
cat > $basedir/nodejs/yrexpert-jsSilent.js << EOF
{
    "silent": true,
    "extras": true
}
EOF
# Mettre les droits corrects
chown $instance:$instance $basedir/nodejs/yrexpert-jsSilent.js

# Créer un script d'installation silencieux pour yrexpert-term
cat > $basedir/nodejs/yrexpert-termSilent.js << EOF
{
    "silent": true,
    "extras": true
}
EOF
# Mettre les droits corrects
chown $instance:$instance $basedir/nodejs/yrexpert-termSilent.js

# Installer les modules de node requis dans $basedir/nodejs
cd $basedir/nodejs
#echo "0/5 Initialiser le fichier package.json"
su $instance -c "source $basedir/.nvm/nvm.sh && source $basedir/config/env && nvm use $nodever && npm set init.author.name 'yrelay' >> $basedir/log/initNpm.log"
su $instance -c "source $basedir/.nvm/nvm.sh && source $basedir/config/env && nvm use $nodever && npm set init.author.email 'info@yrelay.fr' >> $basedir/log/initNpm.log"
su $instance -c "source $basedir/.nvm/nvm.sh && source $basedir/config/env && nvm use $nodever && npm set init.author.url 'https://www.yrelay.fr' >> $basedir/log/initNpm.log"
su $instance -c "source $basedir/.nvm/nvm.sh && source $basedir/config/env && nvm use $nodever && npm set init.license 'GPL-3.0' >> $basedir/log/initNpm.log"
su $instance -c "source $basedir/.nvm/nvm.sh && source $basedir/config/env && nvm use $nodever && npm init -y >> $basedir/log/initNpm.log"

# Installer en mode global les outils de développement
echo "1/6 browserify" # http://doc.progysm.com/doc/browserify
su $instance -c "source $basedir/.nvm/nvm.sh && source $basedir/config/env && nvm use $nodever && npm install --quiet -g browserify >> $basedir/log/installerBrowserify.log"
echo "2/6 uglify-es"
su $instance -c "source $basedir/.nvm/nvm.sh && source $basedir/config/env && nvm use $nodever && npm install --quiet -g uglify-es >> $basedir/log/installerUglify-es.log"
echo "3/6 marked"
su $instance -c "source $basedir/.nvm/nvm.sh && source $basedir/config/env && nvm use $nodever && npm install --quiet -g marked >> $basedir/log/installerMarked.log"
echo "4/6 jsdoc"
su $instance -c "source $basedir/.nvm/nvm.sh && source $basedir/config/env && nvm use $nodever && npm install --quiet -g jsdoc >> $basedir/log/installerJsdoc.log"

# Installer les modules locaux
echo "5/6 yrexpert-js"
su $instance -c "source $basedir/.nvm/nvm.sh && source $basedir/config/env && nvm use $nodever && npm install --quiet --save-prod yrexpert-js >> $basedir/log/installerYrexpert-js.log"
echo "6/6 babelify@next"
su $instance -c "source $basedir/.nvm/nvm.sh && source $basedir/config/env && nvm use $nodever && npm install --quiet --save-dev babelify@next >> $basedir/log/installerBabelify@next.log"

# Certaines distributions linux installent nodejs non comme exécutable "node" mais comme "nodejs".
# Dans ce cas, vous devez lier manuellement à "node", car de nombreux paquets sont programmés après le node "binaire". Quelque chose de similaire se produit également avec "python2" non lié à "python".
# Dans ce cas, vous pouvez faire un lien symbolique. Pour les distributions linux qui installent des binaires de package dans /usr/bin, vous pouvez faire
if [ -h /usr/bin/nodejs ]; then
  rm -f /usr/bin/nodejs
fi
ln -s /usr/bin/node /usr/bin/nodejs

echo "Créer le fichier bundle.js requis par l'application"
su $instance -c "cd $basedir/nodejs/node_modules/yrexpert-js && rm -rf build && mkdir build"
su - $instance -c "cd $basedir/nodejs/node_modules/yrexpert-js/src/js && browserify -t [ babelify --presets [@babel/preset-env @babel/preset-react] ] App.js | uglifyjs > ../../build/bundle.js"

su $instance -c "cd $basedir/nodejs/node_modules/yrexpert-js && cp -f src/index.html build/index.html"
su $instance -c "cd $basedir/nodejs/node_modules/yrexpert-js && cp -f src/css/json-inspector.css build/json-inspector.css"
su $instance -c "cd $basedir/nodejs/node_modules/yrexpert-js && cp -f src/css/Select.css build/Select.css"
su $instance -c "cd $basedir/nodejs/node_modules/yrexpert-js && cp -rf src/images build/images"
# Mettre les droits
chown -R $instance:$instance $basedir/nodejs/node_modules/yrexpert-js/build
chmod -R g+rw $basedir/nodejs/node_modules/yrexpert-js/build
rm -rf $basedir/nodejs/www/yrexpert
if [ ! -d "$basedir/nodejs/www/yrexpert" ];then
  su $instance -c "mkdir $basedir/nodejs/www/yrexpert && cp -rf $basedir/nodejs/node_modules/yrexpert-js/build/* $basedir/nodejs/www/yrexpert"
  su $instance -c "mkdir $basedir/nodejs/www/yrexpert/docs && cp -rf $basedir/nodejs/node_modules/yrexpert-js/docs/* $basedir/nodejs/www/yrexpert/docs"
  su $instance -c "mkdir $basedir/nodejs/www/yrexpert/help && cp -rf $basedir/nodejs/node_modules/yrexpert-js/help/* $basedir/nodejs/www/yrexpert/help"
  # Mettre les droits
  chown -R $instance:$instance $basedir/nodejs/www/yrexpert
  chmod -R g+rw $basedir/nodejs/www/yrexpert
fi

# Créer le répertoire docs utilisé par l'application
echo "Créer les docs de l'application"
su $instance -c "cd $basedir/nodejs/node_modules/yrexpert-js && rm -rf docs && mkdir docs"
su - $instance -c "cd $basedir/nodejs/node_modules/yrexpert-js && jsdoc lib src -r -d docs"
# Mettre les droits
chown -R $instance:$instance $basedir/nodejs/node_modules/yrexpert-js/docs
chmod -R g+rw $basedir/nodejs/node_modules/yrexpert-js/docs

# Copier toutes les routines de yrexpert-js
su $instance -c "find $basedir/nodejs/node_modules/yrexpert-js -name \"*.m\" -type f -exec cp {} $basedir/p/ \;"

# Configurer de GTM C Callin
# avec nodem 0.3.3 le nom de la ci a changé. Déterminer l'utilisation ls -1
calltab=$(ls -1 $basedir/nodejs/node_modules/nodem/resources/*.ci)
echo "export GTMCI=$calltab" >> $basedir/config/env
# Ajouter les routines nodem dans gtmroutines
echo "export gtmroutines=\"\${gtmroutines}\"\" \"\$basedir/nodejs/node_modules/nodem/src" >> $basedir/config/env

# Créer la configuration ewd.js
cat > $basedir/nodejs/node_modules/yrelay-config.js << EOF
module.exports = {
  setParams: function() {
    return {
      ssl: true
    };
  }
};
EOF

# Mettre les droits corrects
chown $instance:$instance $basedir/nodejs/node_modules/yrelay-config.js

# Installer les droits webservice
##echo "Installer les droits webservice"
##su $instance -c "source $basedir/.nvm/nvm.sh && source $basedir/config/env && nvm use $nodever && cd $basedir/nodejs && node registerWSClient.js"

# Modifier les scripts init.d pour les rendre compatibles avec $instance
perl -pi -e 's#y-instance#'$instance'#g' $basedir/config/init.d/yrexpert-js

# Créer le démarrage de service
# TODO: Faire fonctionner avec un lien -h
if [ -f /etc/init.d/${instance}yrexpert-js ]; then
    rm /etc/init.d/${instance}yrexpert-js
fi
#ln -s $basedir/config/init.d/yrexpert-js /etc/init.d/${instance}yrexpert-js
cp $basedir/config/init.d/yrexpert-js /etc/init.d/${instance}yrexpert-js

# Installer le script init
if [[ $debian || -z $RHEL ]]; then
    update-rc.d ${instance}yrexpert-js defaults 85 15
fi

if [[ $RHEL || -z $debian ]]; then
    #TODO: à modifier
    #chkconfig --add ${instance}yrexpert-js
    echo "voir TODO..."
fi

# Add firewall rules
if [[ $RHEL || -z $debian ]]; then
    iptables -I INPUT 1 -p tcp --dport 8080 -j ACCEPT # EWD.js
    iptables -I INPUT 1 -p tcp --dport 8000 -j ACCEPT # EWD.js Webservices
    iptables -I INPUT 1 -p tcp --dport 8081 -j ACCEPT # EWD yrexpert Term
    iptables -I INPUT 1 -p tcp --dport 8082 -j ACCEPT # Pour test
    iptables -I INPUT 1 -p tcp --dport 3000 -j ACCEPT # Débuggeur node-inspector

    service iptables save
fi

# Démarrer le service
systemctl daemon-reload
service ${instance}yrexpert-js start

echo "Installation EWD.js terminée..."





