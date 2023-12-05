#! /bin/bash

echo "Running setupDirectoriesAndScriptsForEclipseForCora..."

USER=$1
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)
PARENTDIR="$(dirname "$BASEDIR")"
INSTALLDIR=$PARENTDIR/eclipse202309forcora2
TOPDIR="$(dirname "$PARENTDIR")"

echo 
echo script: $SCRIPT
echo basedir: $BASEDIR
echo parentdir: $PARENTDIR
echo installdir: $INSTALLDIR

createDirectories(){
  	mkdir $INSTALLDIR
  	mkdir $INSTALLDIR/eclipse
  	mkdir $INSTALLDIR/.eclipse
  	mkdir $INSTALLDIR/.saros
  	mkdir $INSTALLDIR/workspace
 	mkdir $PARENTDIR/m2
  	mkdir $PARENTDIR/eclipseP2
  	mkdir $PARENTDIR/sharedArchive
  	mkdir $PARENTDIR/sharedArchive/systemOne
  	mkdir $PARENTDIR/sharedArchive/alvin
  	mkdir $PARENTDIR/sharedArchive/diva
  	mkdir $PARENTDIR/sharedFileStorage
  	mkdir $PARENTDIR/sharedFileStorage/systemOne
  	mkdir $PARENTDIR/sharedFileStorage/alvin
  	mkdir $PARENTDIR/sharedFileStorage/diva
}
	
changeAndCopyScripts(){
	cp $BASEDIR/startEclipseForCora.sh $INSTALLDIR/
	sed -i "s|INSTALLDIR|$INSTALLDIR|g" $INSTALLDIR/startEclipseForCora.sh
	sed -i "s|PARENTDIR|$PARENTDIR|g" $INSTALLDIR/startEclipseForCora.sh

	cp $BASEDIR/startEclipseForCoraTempSetup.sh $INSTALLDIR/
	sed -i "s|INSTALLDIR|$INSTALLDIR|g" $INSTALLDIR/startEclipseForCoraTempSetup.sh
	sed -i "s|PARENTDIR|$PARENTDIR|g" $INSTALLDIR/startEclipseForCoraTempSetup.sh

	cp $BASEDIR/startEclipseForCoraNoPorts.sh $INSTALLDIR/
	sed -i "s|INSTALLDIR|$INSTALLDIR|g" $INSTALLDIR/startEclipseForCoraNoPorts.sh
	sed -i "s|PARENTDIR|$PARENTDIR|g" $INSTALLDIR/startEclipseForCoraNoPorts.sh
	
	cp $BASEDIR/development/projectListing.sh $INSTALLDIR/projectListing.sh
	cp $BASEDIR/development/setupProjects.sh $INSTALLDIR/setupProjects.sh
	
	cp $BASEDIR/docker/docker-compose.yml $INSTALLDIR/
	cp $BASEDIR/docker/Dockerfile $INSTALLDIR/
	cp $BASEDIR/docker/entrypoint.sh $INSTALLDIR/
	
	cp $BASEDIR/docker/derived $INSTALLDIR/workspace/.derived
}

createGitConfigFile(){
	touch $PARENTDIR/.gitconfig
}

createArchiveReadableFile(){
	rm $PARENTDIR/archiveReadable
	touch $PARENTDIR/archiveReadable.sh
	echo "docker exec -u 0 eclipse202309forcora2 bindfs --map=root/$USER:@root/@$USER /tmp/sharedArchive/ /tmp/sharedArchiveReadable/" > $PARENTDIR/archiveReadable.sh
	chmod +x $PARENTDIR/archiveReadable.sh
}

createSharedFileStorageReadableFile(){
	rm $PARENTDIR/sharedFileStorage
	touch $PARENTDIR/sharedFileStorage.sh
	echo "docker exec -u 0 eclipse202309forcora2 bindfs --map=root/$USER:@root/@$USER /tmp/sharedFileStorage/ /tmp/sharedFileStorage/" > $PARENTDIR/sharedFileStorage.sh
	chmod +x $PARENTDIR/sharedFileStorage.sh
}

if [ ! -d $INSTALLDIR ]; then
	createDirectories
	changeAndCopyScripts
	createGitConfigFile
	createArchiveReadableFile
	createSharedFileStorageReadableFile
fi
