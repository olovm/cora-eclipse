#! /bin/bash
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)
echo basedir: $BASEDIR

USER=$(id -u -n)

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
  	echo "You must specify the userName used when starting eclipse202212forcora3"
else
	#${CONTAINERRUNTIME} run --rm -ti --privileged --ipc=host --env="QT_X11_NO_MITSHM=1"  -e DISPLAY=$DISPLAY \
cd eclipse202212forcora3
#docker-compose run -e DISPLAY=$DISPLAY\
#${CONTAINERRUNTIME} run --rm -ti --privileged --net=host --ipc=host --env="QT_X11_NO_MITSHM=1"  -e DISPLAY=$DISPLAY \
${CONTAINERRUNTIME} run --rm -ti --privileged  --ipc=host \
 --env="QT_X11_NO_MITSHM=1"\
 -e DISPLAY=$DISPLAY \
 -e XDG_RUNTIME_DIR=/tmp \
 -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
 -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY \
 -v /var/run/docker.sock:/var/run/docker.sock\
 -v /tmp/.X11-unix:/tmp/.X11-unix\
 -v /mnt/depot/cora/eclipse202212forcora3/workspace:/home/$USER/workspace\
 -v /mnt/depot/cora/eclipse202212forcora3/eclipse:/home/$USER/eclipse\
 -v /mnt/depot/cora/eclipse202212forcora3/.eclipse:/home/$USER/.eclipse\
 -v /mnt/depot/cora/eclipse202212forcora3/.saros:/home/$USER/.saros\
 -v /mnt/depot/cora/m2:/home/$USER/.m2\
 -v /mnt/depot/cora/eclipseP2:/home/$USER/.p2\
 -v /mnt/depot/cora/.gitconfig:/home/$USER/.gitconfig\
 -e user=$USER\
 -e HOSTBASEDIR=$BASEDIR\
 -p 39876:9876\
 -p 38080:8080\
 -p 38180:8180\
 -p 38280:8280\
 -p 38380:8380\
 -p 38081:8081\
 -p 38181:8181\
 -p 38281:8281\
 -p 38381:8381\
 -p 38082:8082\
 -p 38182:8182\
 -p 38282:8282\
 -p 38382:8382\
 -p 38090:8090\
 -p 38091:8091\
 -p 38092:8092\
 --network=eclipseForCoraNet\
 --name eclipse202212forcora3\
 eclipse202212forcora3 $2
 cd ../
fi

#5432 postgresql (exposed directly from that container)
#9876 karma
#8080 tomcat
#8090 fitnesse
#8983 solr (exposed directly from that container)

#  -p 8080:8080 -p 9876:9876 -p 8090:8090 -p 8983:8983 -p 5432:5432\
