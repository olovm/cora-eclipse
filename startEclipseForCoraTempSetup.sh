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
cd eclipse202309forcora1
${CONTAINERRUNTIME} run --rm -ti --privileged --ipc=host\
 --env="QT_X11_NO_MITSHM=1"\
 --env="NO_AT_BRIDGE=1"\
 -e DISPLAY=$DISPLAY\
 -e XDG_RUNTIME_DIR=/tmp\
 -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY\
 -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY\
 -v /var/run/docker.sock:/var/run/docker.sock\
 -v /usr/lib64/dri:/usr/lib64/dri\
 -v /tmp/.X11-unix:/tmp/.X11-unix\
 -v INSTALLDIR/workspace:/home/$USER/workspace\
 -v INSTALLDIR/eclipse:/home/$USER/eclipse\
 -v INSTALLDIR/.eclipse:/home/$USER/.eclipse\
 -v INSTALLDIR/.saros:/home/$USER/.saros\
 -v PARENTDIR/m2:/home/$USER/.m2\
 -v PARENTDIR/eclipseP2:/home/$USER/.p2\
 -v PARENTDIR/.gitconfig:/home/$USER/.gitconfig\
 -v PARENTDIR/ssh:/home/$USER/.ssh\
 -v PARENTDIR/sharedArchive:/tmp/sharedArchive\
 -v PARENTDIR/archiveReadable.sh:/home/$USER/archiveReadable.sh\
 -e user=$USER\
 -e eclipsebranch=$ECLIPSEBRANCH\
 --network=eclipseForCoraNet\
 --name eclipse202103forcora3TempSetup\
 eclipse202309forcora1
 cd ../
fi
