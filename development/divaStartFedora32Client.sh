#! /bin/bash

echo "starting fedora 32 client"
#docker run -d --name cora-docker-fedora32-client --rm \

docker run  --rm --privileged  --ipc=host --env="QT_X11_NO_MITSHM=1"  -e DISPLAY=$DISPLAY \
 -v /var/run/docker.sock:/var/run/docker.sock\
 -v /tmp/.X11-unix:/tmp/.X11-unix\
 --name cora-docker-fedora32-client  \
 --network=eclipseForCoraNet \
 cora-docker-fedora32-client:1.0-SNAPSHOT
