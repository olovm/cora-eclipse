#! /bin/bash

USER=$(id -u -n)
USERID=$(id -u)
DOCKERGROUPID=$1
ECLIPSEBRANCH=$2
NOCACHE=$3

if [ ! $ECLIPSEBRANCH ]; then
	ECLIPSEBRANCH='master'
fi

echo 
echo "running runAll.sh..."
echo running all using:
echo userName: $USER
echo userId: $USERID
echo dockerGroupId: $DOCKERGROUPID
echo cora-eclipse branch: $ECLIPSEBRANCH


if [ ! $USER ]; then
  	echo you must specify the userName to be used when building eclipse202503forcora2
elif [ ! $USERID ]; then
	echo you must specify the userid to be used when building eclipse202503forcora2, use: id -u youruserid 
elif [ ! $DOCKERGROUPID ] && [ ! -d ./eclipseForCora ]; then
	echo you must specify the dockergroupid to be used when building eclipse202503forcora2, use: getent group docker 
else
	if [ ! -d ./eclipse202503forcora2 ]; then
		./cora-eclipse/buildEclipseForCora.sh $USER $USERID $DOCKERGROUPID $NOCACHE
		./cora-eclipse/setupDirectoriesAndScriptsForEclipseForCora.sh $USER
		docker network create eclipseForCoraNet
		docker network create eclipseForAlvinNet
		docker network create eclipseForDivaNet
	fi
	./eclipse202503forcora2/startEclipseForCoraTempSetup.sh $USER $ECLIPSEBRANCH
fi