#! /bin/bash

USER=$1

if [ ! $USER ]; then
  	echo you must specify the userName to be used when building eclipseforcora2
else
	docker build --build-arg user=$USER -t eclipseforcora2 cora-eclipse/docker/
fi
