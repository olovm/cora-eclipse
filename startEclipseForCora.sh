#! /bin/bash

USER=$1

if [ ! $USER ]; then
  	echo you must specify the userName used when building eclipseforcora1
else
	docker run --rm -ti --privileged -e DISPLAY=$DISPLAY \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /mnt/depot/eclipseForCora/workspace:/home/$USER/workspace \
	-v /mnt/depot/eclipseForCora/eclipse:/home/$USER/eclipse \
	-v /mnt/depot/eclipseP2:/home/$USER/.p2 \
	-v /mnt/depot/eclipseForCora/m2:/home/$USER/.m2 \
	--env user=$USER -p 8080:8080 -p 9876:9876 -p 8090:8090 --name eclipseforcora1 eclipseforcora1
	
fi
