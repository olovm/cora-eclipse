#! /bin/bash

#USER=$1
USER=$(id -u -n)
BASEDIR=$(dirname $BASH_SOURCE)

echo starting eclipse using:
echo userName: $USER

if [ ! $USER ]; then
  	echo "You must specify the userName used when starting eclipse201809forcora6TempSetup"
else
cd eclipseForCora
docker run --rm -ti --privileged --ipc=host --env="QT_X11_NO_MITSHM=1"  -e DISPLAY=$DISPLAY \
 -v /var/run/docker.sock:/var/run/docker.sock\
 -v /tmp/.X11-unix:/tmp/.X11-unix\
 -v INSTALLDIR/workspace:/home/$USER/workspace\
 -v INSTALLDIR/eclipse:/home/$USER/eclipse\
 -v INSTALLDIR/.eclipse:/home/$USER/.eclipse\
 -v INSTALLDIR/m2:/home/$USER/.m2\
 -v PARENTDIR/eclipseP2:/home/$USER/.p2\
 -e user=$USER\
 --network=eclipseForCoraNet\
 --name eclipse201809forcora6TempSetup\
 eclipse201809forcora6 $2
 cd ../
fi
# -p 8080:8080 -p 9876:9876 -p 8090:8090\
# -p 8081:8081\
# -p 8082:8082\
