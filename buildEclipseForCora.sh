#! /bin/bash

USER=$1
USERID=$2
DOCKERGROUPID=$3
NOCACHE=$4
echo "running buildEclipseForCora.sh..."

echo "Testing for container runtimes...."
CONTAINERRUNTIME=podman;
DOCKER_EXISTS=$(command -v docker)
echo "Docker size: "${#DOCKER_EXISTS}
if [ ${#DOCKER_EXISTS} -gt 0 ]; then
	CONTAINERRUNTIME=docker;
fi
echo "Container runtime will be "${CONTAINERRUNTIME}

if [ ! $USER ]; then
  	echo you must specify the userName to be used when building eclipse202103forcora3
elif [ ! $USERID ]; then
	echo you must specify the userid to be used when building eclipse202103forcora3, use: id -u youruserid 
elif [ ! $DOCKERGROUPID ]; then
	echo you must specify the dockergroupid to be used when building eclipse202103forcora3, use: getent group docker 
else
	#for possibly newer version of from: X
	#docker build --pull --no-cache --build-arg user=$USER --build-arg dockergroupid=$DOCKERGROUPID -t eclipseforcoraoxygen2 cora-eclipse/docker/
#	 --no-cache \
	if [ ! $NOCACHE ]; then
		${CONTAINERRUNTIME} build \
		 --build-arg user=$USER \
		 --build-arg userid=$USERID \
		 --build-arg dockergroupid=$DOCKERGROUPID \
		 -t eclipse202103forcora3 cora-eclipse/docker/
	else
		${CONTAINERRUNTIME} build --no-cache --pull \
		 --build-arg user=$USER \
		 --build-arg userid=$USERID \
		 --build-arg dockergroupid=$DOCKERGROUPID \
		 -t eclipse202103forcora3 cora-eclipse/docker/
	fi
	#${CONTAINERRUNTIME} build --build-arg user=$USER -t eclipseforcoraoxygen2 cora-eclipse/docker/
	#cd cora-eclipse/docker/
	#docker-compose build --build-arg user=$USER eclipseforcoraoxygen2
	#docker-compose build --no-cache --build-arg user=$USER eclipseforcoraoxygen2
fi
