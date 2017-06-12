# cora-eclipse
Cora-eclipse is a project to enable easy setup of an Eclipse install for Cora development, using Eclipse and Docker.</br>
I am running this on linux so, change as needed for other platforms.

## Getting started
1. Make sure you have git and docker set up on your local machine
2. Clone this repository: `git clone https://github.com/olovm/cora-eclipse.git`

## Build docker image
Replace `yourUserName` with with your desired username.</br>
Run:</br>
`./cora-eclipse/buildEclipseForCora.sh yourUserName`
or:</br>
 `docker build --build-arg user=yourUserName -t eclipseforcora3 cora-eclipse/docker/`</br>
this will take some time as it downloads quite a few things

## Create directories on host 
To get persistent storage in the container, create the following directories</br>
` ./cora-eclipse/setupDirectoriesAndScriptsForEclipseForCora.sh`</br>
or:</br>
1. workspace (for your eclipse workspace)
2. eclipse (for your eclipse installation)
3. eclipseP2 (for files shared between multiple installations of eclipse)
4. m2 (for maven files)


## First run installing eclipse
I am using path `/mnt/depot/eclipseForCora` replace that with where you created your directories above.
Replace `yourUserName` with with your desired username (must be the same as you used when building the image)</br>
</br>
` ./eclipseForCora/startEclipseForCora.sh yourUserName`</br>
or:</br>
Run:</br>
`docker run --rm -ti --privileged -e DISPLAY=$DISPLAY 
-v /tmp/.X11-unix:/tmp/.X11-unix 
-v /mnt/depot/eclipseForCora/workspace:/home/yourUserName/workspace 
-v /mnt/depot/eclipseForCora/eclipse:/home/yourUserName/eclipse 
-v /mnt/depot/eclipseP2:/home/yourUserName/.p2 
-v /mnt/depot/eclipseForCora/m2:/home/yourUserName/.m2 
--env user=yourUserName -p 8080:8080 -p 9876:9876 -p 8090:8090 --name eclipseforcora3 eclipseforcora3`

### Eclipse installation
When the container starts for the first time will it runthe installation part of entrypoint.sh. This will
clone all Cora repositories, add other remotes to all of them, install needed npm karma in cora-jsclient and
start the eclipse installer (oomph). </br>
There are a few things that needs to be choosen in the installer. 

1. You need to use the advanced mode and
browse for setup files for eclipse and cora, they are called EclipseForCora.setup and CoraProjects.setup, and
can be found in /home/yourUserName/workspace/cora-eclipse/oomph. 
2. Use absolute path for your eclipse installation, set it to /home/yourUserName/eclipse
3. Fill in path for Installation location, set it to /home/yourUserName/eclipse
4. Use absolute path for your workspace, set it to /home/yourUserName/workspace
This should get you through the installer and will eventually start eclipse and do a first run to setup eclipse. 

## Starting server
Before starting the server go into the launch configuration / classpath and under User Entries add<br>
cora-basicstorage/target/cora-basicstorage-0.5-SNAPSHOT.jar<br>
cora-systemone/target/cora-systemone-0.13-SNAPSHOT.jar<br>
