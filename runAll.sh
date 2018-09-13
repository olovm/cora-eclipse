#! /bin/bash

USER=$1
USERID=$2
DOCKERGROUPID=$3

if [ ! $USER ]; then
  	echo you must specify the userName to be used when building eclipseforcoraoxygen
elif [ ! $DOCKERGROUPID ]; then
	echo you must specify the userid to be used when building eclipseforcoraphoton, use: id -u youruserid 
elif [ ! $DOCKERGROUPID ] && [ ! -d ./eclipseForCora ]; then
	echo you must specify the dockergroupid to be used when building eclipseforcoraoxygen, use: getent group docker 
else
	if [ ! -d ./eclipseForCora ]; then
		./cora-eclipse/buildEclipseForCora.sh $USER $USERID $DOCKERGROUPID
		./cora-eclipse/setupDirectoriesAndScriptsForEclipseForCora.sh
		docker network create eclipseForCoraNet
	fi
	./eclipseForCora/startEclipseForCora.sh $USER
fi