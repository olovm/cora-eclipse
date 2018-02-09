#! /bin/bash

USER=$1
DOCKERGROUPID=$2

if [ ! $USER ]; then
  	echo you must specify the userName to be used when building eclipseforcoraoxygen
elif [ ! $DOCKERGROUPID ] && [ ! -d ./eclipseForCora ]; then
	echo you must specify the dockergroupid to be used when building eclipseforcoraoxygen, use: getent group docker 
else
	if [ ! -d ./eclipseForCora ]; then
		./cora-eclipse/buildEclipseForCora.sh $USER $DOCKERGROUPID
		./cora-eclipse/setupDirectoriesAndScriptsForEclipseForCora.sh
	fi
	./eclipseForCora/startEclipseForCora.sh $USER
fi
