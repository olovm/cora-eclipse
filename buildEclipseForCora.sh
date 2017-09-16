#! /bin/bash

USER=$1

if [ ! $USER ]; then
  	echo you must specify the userName to be used when building eclipseforcoraoxygen1
else
	#for possibly newer version of from: X
	#docker build --pull --build-arg user=$USER -t eclipseforcoraoxygen1 cora-eclipse/docker/
	#docker build --build-arg user=$USER -t eclipseforcoraoxygen1 cora-eclipse/docker/
	docker-compose build --build-arg user=$USER
fi
