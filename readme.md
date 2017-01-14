#cora-eclipse
Cora-eclipse is a project to enable easy setup of an Eclipse install for Cora development, using Eclipse and Docker.

##Getting started
1. Make sure you have git and docker set up on your local machine
2. Clone this repository: `git clone https://github.com/olovm/cora-eclipse.git`

##Build docker image
Run:
 `docker build --build-arg user=yourUserName -t eclipseforcora1 cora-eclipse/docker/`
this will take some time as it downloads quite a few things

##First run installing eclipse
Run:
`xhost + && docker run --rm -ti --privileged -e DISPLAY=$DISPLAY \`
`-v /tmp/.X11-unix:/tmp/.X11-unix \`
`-v /mnt/depot/eclipseForCora/workspace:/home/olov/workspace \`
` -v /mnt/depot/eclipseForCora/eclipse:/home/olov/eclipse \`
`-v /mnt/depot/eclipseP2:/home/olov/.p2 \`
`-v /mnt/depot/eclipseForCora/m2:/home/olov/.m2 \`
`--env user=olov -p 8080:8080 -p 9876:9876 eclipseforcora1`