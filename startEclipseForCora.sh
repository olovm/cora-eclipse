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
  	echo "You must specify the userName used when starting eclipse202203forcora2"
else
	#${CONTAINERRUNTIME} run --rm -ti --privileged --ipc=host --env="QT_X11_NO_MITSHM=1"  -e DISPLAY=$DISPLAY \
cd eclipse202203forcora2
#docker-compose run -e DISPLAY=$DISPLAY\
#${CONTAINERRUNTIME} run --rm -ti --privileged --net=host --ipc=host --env="QT_X11_NO_MITSHM=1"  -e DISPLAY=$DISPLAY \
${CONTAINERRUNTIME} run --rm -ti --privileged  --ipc=host --env="QT_X11_NO_MITSHM=1"  --env="NO_AT_BRIDGE=1"  -e DISPLAY=$DISPLAY \
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
 -e user=$USER\
 -e HOSTBASEDIR=$BASEDIR\
 -e sharedArchive=PARENTDIR/sharedArchive\
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
 --name eclipse202203forcora2\
 --network-alias=eclipse\
 eclipse202203forcora2 $2
 cd ../
fi

#5432 postgresql (exposed directly from that container)
#9876 karma
#8080 tomcat
#8090 fitnesse
#8983 solr (exposed directly from that container)

#  -p 8080:8080 -p 9876:9876 -p 8090:8090 -p 8983:8983 -p 5432:5432\
