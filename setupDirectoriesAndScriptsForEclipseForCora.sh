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
  	mkdir $PARENTDIR/eclipseForCora/workspace
 	mkdir $PARENTDIR/eclipseForCora/m2
  	mkdir $PARENTDIR/eclipseP2
}
changeAndCopyScripts(){
	
	cp $BASEDIR/startEclipseForCora.sh $PARENTDIR/eclipseForCora/
	sed -i "s|INSTALLDIR|$INSTALLDIR|g" $PARENTDIR/eclipseForCora/startEclipseForCora.sh
	sed -i "s|PARENTDIR|$PARENTDIR|g" $PARENTDIR/eclipseForCora/startEclipseForCora.sh
	
	#cp $BASEDIR/buildEclipseForCora.sh $PARENTDIR/eclipseForCora/
	#sed -i "s|INSTALLDIR|$INSTALLDIR|g" $PARENTDIR/eclipseForCora/buildEclipseForCora.sh
	
	
}

if [ ! -d $PARENTDIR/eclipseForCora ]; then
	createDirectories
	changeAndCopyScripts
fi
