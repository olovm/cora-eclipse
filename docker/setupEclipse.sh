#! /bin/bash
 
#usermod -u $MY_UID -g $MY_GID me
#su me -c eclipse
#cd /home/$USER/
#wget http://saimei.acc.umu.se/mirror/eclipse.org/oomph/epp/neon/R1/eclipse-inst-linux64.tar.gz
#wget http://saimei.acc.umu.se/mirror/eclipse.org/technology/epp/downloads/release/neon/1a/eclipse-jee-neon-1a-linux-gtk-x86_64.tar.gz
#tar -zxvf eclipse-jee-neon-1a-linux-gtk-x86_64.tar.gz

#if ["$USER" != ""];then
#user=$USER;
#fi

if [ -z ${USER+x} ]; then 
echo "USER is unset"; 
else 
echo "USER is set to '$USER'"; 
user=$USER
export user
fi

echo "user: '$user'"

#sed -i '1i -pluginCustomization plugin_customization.ini' /home/$user/eclipse/eclipse.ini


/home/$user/eclipse/eclipse \
-application org.eclipse.equinox.p2.director \
-noSplash \
-repository \
http://download.eclipse.org/eclipse/updates/4.7,\
http://eclipse.sonarlint.org,\
http://update.eclemma.org,\
http://beust.com/eclipse,\
http://findbugs.cs.umd.edu/eclipse \
-installIUs \
com.mountainminds.eclemma.feature.feature.group,\
org.testng.eclipse.feature.group,\
org.testng.eclipse.maven.feature.feature.group,\
edu.umd.cs.findbugs.plugin.eclipse

#,\
#edu.umd.cs.findbugs.plugins.eclipse,\
#org.sonarlint.eclipse.jdt.feature,\
#org.sonarlint.eclipse.feature
