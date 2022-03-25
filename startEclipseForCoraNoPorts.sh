#! /bin/bash

#USER=$1
USER=$(id -u -n)
BASEDIR=$(dirname $BASH_SOURCE)

echo 
echo starting eclipse using:
echo userName: $USER
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
  	echo "You must specify the userName used when starting eclipse202203forcora1"
else
	#${CONTAINERRUNTIME} run --rm -ti --privileged --ipc=host --env="QT_X11_NO_MITSHM=1"  -e DISPLAY=$DISPLAY \
cd eclipse202203forcora1
#docker-compose run -e DISPLAY=$DISPLAY\
#${CONTAINERRUNTIME} run --rm -ti --privileged --net=host --ipc=host --env="QT_X11_NO_MITSHM=1"  -e DISPLAY=$DISPLAY \
${CONTAINERRUNTIME} run --rm -ti --privileged  --ipc=host --env="QT_X11_NO_MITSHM=1"  -e DISPLAY=$DISPLAY \
 -v /var/run/docker.sock:/var/run/docker.sock\
 -v /tmp/.X11-unix:/tmp/.X11-unix\
 -v INSTALLDIR/workspace:/home/$USER/workspace\
 -v INSTALLDIR/eclipse:/home/$USER/eclipse\
 -v INSTALLDIR/.eclipse:/home/$USER/.eclipse\
 -v INSTALLDIR/.saros:/home/$USER/.saros\
 -v PARENTDIR/m2:/home/$USER/.m2\
 -v PARENTDIR/eclipseP2:/home/$USER/.p2\
 -v PARENTDIR/.gitconfig:/home/$USER/.gitconfig\
 -e user=$USER\
 --network=eclipseForCoraNet\
 --name eclipse202103forcora3NoPorts\
 eclipse202203forcora1 $2
 cd ../
fi

#5432 postgresql (exposed directly from that container)
#9876 karma
#8080 tomcat
#8090 fitnesse
#8983 solr (exposed directly from that container)

#  -p 8080:8080 -p 9876:9876 -p 8090:8090 -p 8983:8983 -p 5432:5432\
