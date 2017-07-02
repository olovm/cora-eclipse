#! /bin/bash

USER=$1

if [ ! $USER ]; then
  	echo you must specify the userName to be used when building eclipseforcora3
else
	#for possibly newer version of from: X
	#docker build --pull --build-arg user=$USER -t eclipseforcora3 cora-eclipse/docker/
	docker build --build-arg user=$USER -t eclipseforcora3 cora-eclipse/docker/
fi
