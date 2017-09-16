#! /bin/bash

#USER=$1
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)
PARENTDIR="$(dirname "$BASEDIR")"
INSTALLDIR=$PARENTDIR/eclipseForCora
TOPDIR="$(dirname "$PARENTDIR")"

echo script: $SCRIPT
echo basedir: $BASEDIR
echo parentdir: $PARENTDIR

createDirectories(){
  	mkdir $PARENTDIR/eclipseForCora
  	mkdir $PARENTDIR/eclipseForCora/eclipse
  	mkdir $PARENTDIR/eclipseForCora/.eclipse
  	mkdir $PARENTDIR/eclipseForCora/workspace
 	mkdir $PARENTDIR/eclipseForCora/m2
  	mkdir $PARENTDIR/eclipseP2
  	mkdir $PARENTDIR/solr
}
	
changeAndCopyScripts(){
	cp $BASEDIR/startEclipseForCora.sh $PARENTDIR/eclipseForCora/
	sed -i "s|INSTALLDIR|$INSTALLDIR|g" $PARENTDIR/eclipseForCora/startEclipseForCora.sh
	sed -i "s|PARENTDIR|$PARENTDIR|g" $PARENTDIR/eclipseForCora/startEclipseForCora.sh
	
	#cp $BASEDIR/buildEclipseForCora.sh $PARENTDIR/eclipseForCora/
	#sed -i "s|INSTALLDIR|$INSTALLDIR|g" $PARENTDIR/eclipseForCora/buildEclipseForCora.sh
	
	cp $BASEDIR/development/projectListing.sh $PARENTDIR/eclipseForCora/projectListing.sh
	cp $BASEDIR/development/setupProjects.sh $PARENTDIR/eclipseForCora/setupProjects.sh
	
	cp $BASEDIR/docker/docker-compose.yml $PARENTDIR/eclipseForCora/
	cp $BASEDIR/docker/Dockerfile $PARENTDIR/eclipseForCora/
	cp $BASEDIR/docker/entrypoint.sh $PARENTDIR/eclipseForCora/
}

createGitConfigFile(){
	touch $PARENTDIR/.gitconfig
}

if [ ! -d $PARENTDIR/eclipseForCora ]; then
	createDirectories
	changeAndCopyScripts
	createGitConfigFile
fi
