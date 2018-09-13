#! /bin/bash

USER=$1
USERID=$2
DOCKERGROUPID=$3

if [ ! $USER ]; then
  	echo you must specify the userName to be used when building eclipseforcoraphoton
elif [ ! $USERID ]; then
	echo you must specify the userid to be used when building eclipseforcoraphoton, use: id -u youruserid 
elif [ ! $DOCKERGROUPID ]; then
	echo you must specify the dockergroupid to be used when building eclipseforcoraphoton, use: getent group docker 
else
	#for possibly newer version of from: X
	#docker build --pull --no-cache --build-arg user=$USER --build-arg dockergroupid=$DOCKERGROUPID -t eclipseforcoraoxygen2 cora-eclipse/docker/
	docker build --build-arg user=$USER --build-arg userid=$USERID --build-arg dockergroupid=$DOCKERGROUPID -t eclipseforcoraphoton1 cora-eclipse/docker/
	#docker build --build-arg user=$USER -t eclipseforcoraoxygen2 cora-eclipse/docker/
	#cd cora-eclipse/docker/
	#docker-compose build --build-arg user=$USER eclipseforcoraoxygen2
	#docker-compose build --no-cache --build-arg user=$USER eclipseforcoraoxygen2
fi
