#! /bin/bash

#USER=$1
USER=$(id -u -n)
BASEDIR=$(dirname $BASH_SOURCE)
ECLIPSEBRANCH=$2

echo 
echo "running startEclipseForCoraTempSetup.sh..."
echo starting eclipse using:
echo userName: $USER
echo cora-eclipse branch: $ECLIPSEBRANCH
echo 
echo "Testing for container runtimes...."
CONTAINERRUNTIME=podman;
DOCKER_EXISTS=$(command -v docker)
echo "Docker size: "${#DOCKER_EXISTS}
if [ ${#DOCKER_EXISTS} -gt 0 ]; then
	CONTAINERRUNTIME=docker;
fi
echo "Container runtime will be "${CONTAINERRUNTIME}

if [ ! $USER ]; then
  	echo "You must specify the userName used when starting eclipse202103forcora3TempSetup"
else
cd eclipse202203forcora2
#${CONTAINERRUNTIME} run --rm -ti --privileged --net=host --ipc=host --env="QT_X11_NO_MITSHM=1"  -e DISPLAY=$DISPLAY \
${CONTAINERRUNTIME} run --rm -ti --privileged  --ipc=host --env="QT_X11_NO_MITSHM=1"  --env="NO_AT_BRIDGE=1"  -e DISPLAY=$DISPLAY \
 -v /var/run/docker.sock:/var/run/docker.sock\
 -v /usr/lib64/dri:/usr/lib64/dri\
 -v /tmp/.X11-unix:/tmp/.X11-unix\
 -v INSTALLDIR/workspace:/home/$USER/workspace\
 -v INSTALLDIR/eclipse:/home/$USER/eclipse\
 -v INSTALLDIR/.eclipse:/home/$USER/.eclipse\
 -v PARENTDIR/m2:/home/$USER/.m2\
 -v PARENTDIR/eclipseP2:/home/$USER/.p2\
 -e user=$USER\
 -e eclipsebranch=$ECLIPSEBRANCH\
 --network=eclipseForCoraNet\
 --name eclipse202103forcora3TempSetup\
 eclipse202203forcora2
 cd ../
fi
# -p 8080:8080 -p 9876:9876 -p 8090:8090\
# -p 8081:8081\
# -p 8082:8082\
