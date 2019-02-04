# cora-eclipse
Cora-eclipse is a project to enable easy setup of an Eclipse install for Cora development, using Eclipse and Docker.</br>
I am running this on linux so, change as needed for other platforms.

## Getting started
1. Make sure you have git and docker set up on your local machine
2. Clone this repository: `git clone https://github.com/olovm/cora-eclipse.git`

## Installing, runAll
The runAll script will take you through the entire process of setting up a docker based development
environment for Cora. It will go through all needed steps. </br>
Run:</br>
`./cora-eclipse/runAll.sh`

### Build docker image
Automatically run by runAll<br>
this will take some time as it downloads quite a few things, eclipse, tomcat, etc

### Create directories on host 
Automatically run by runAll<br>
1. workspace (for your eclipse workspace)
2. eclipse (for your eclipse installation)
3. eclipseP2 (for files shared between multiple installations of eclipse)
4. m2 (for maven files)

### Docker first run installing eclipse
Automatically run by runAll<br>

#### Eclipse installation
When the container starts for the first time will it run the installation part of entrypoint.sh. This will
clone all Cora repositories, add other remotes to all of them, install needed npm karma in cora-jsclient and
start the eclipse installer (oomph). </br>
**There are a few things that needs to be choosen in the installer:**

1. You need to use the advanced mode and
browse for setup files for eclipse and cora, they are called EclipseForCora.setup and CoraProjects.setup, and
can be found in /home/yourUserName/workspace/cora-eclipse/oomph. 
2. Java 1.8+ VM, set it to: /usr/lib/jvm/java-11-openjdk
3. Use absolute path for your eclipse installation, set it to /home/yourUserName/eclipse
4. Fill in path for Installation location, set it to /home/yourUserName/eclipse
5. Use absolute path for your workspace, set it to /home/yourUserName/workspace
6. JRE 1.8 Location, set it to: /usr/lib/jvm/java-11-openjdk
<br>
This should get you through the installer and will eventually start eclipse and do a first run to setup eclipse. 
You can click on the spinning arrows, in the bottom of the screen to see what the setup does.
<br>
Once the setuptask are finnished, no more spinning arrows, close eclipse, and then close the installer window. 
<br>
You are now ready to do a first startup of the environment. 


## Finishing up, your first startup of the environment
Start the environment by running:</br>
`./eclipseForCora/startEclipseForCora.sh`
<br>
 **Do the following in the listed order to avoid problems!**
 1. In project explorer, under the little arrow, deselect working sets
 2. Mark all projects and refresh them, menu or F5 (this will make sure eclipse sees files in target folders)
 3. Add jars to servers, see instructions below.
 4. Start and stop the servers (in server tab) in the following order:
 ..1. Tomcat v9.0 at localhost
 ..2. Tomcat v9.0 at localhost (alvin)
 ..3. Tomcat v9.0 at localhost (diva)
 5. Go under External Tools Configurations (play icon with toolbox) and run linkJsClientToTomcats
 6. Go under External Tools Configurations (play icon with toolbox) and run copyMetadata

### Adding jars to tomcats
Before starting the server go into the launch configuration / classpath and under User Entries add<br>
For:Tomcat v9.0 at localhost<br>
cora-basicstorage/target/cora-basicstorage-0.5-SNAPSHOT.jar<br>
cora-systemone/target/cora-systemone-0.13-SNAPSHOT.jar<br>
<br>
For:Tomcat v9.0 at localhost (alvin)<br>
cora-basicstorage/target/cora-basicstorage-0.5-SNAPSHOT.jar<br>
cora-systemone/target/alvin-cora-0.x-SNAPSHOT.jar<br>
<br>
<br>
For:Tomcat v9.0 at localhost (diva)<br>
cora-basicstorage/target/cora-basicstorage-0.5-SNAPSHOT.jar<br>
cora-systemone/target/diva-cora-0.x-SNAPSHOT.jar<br>
<br>

### Build all tags
1. Go under External Tools Configurations (play icon with toolbox) and run checkOutLatestTagOfAllProjects
2. Go under External Tools Configurations (play icon with toolbox) and run mvnPomCleanInstallAllButDocker 
3. Go under External Tools Configurations (play icon with toolbox) and run checkOutMasterOfAllProjects

### Start systemOne
1. Go under External Tools Configurations (play icon with toolbox) and start the docker containers for development by running systemoneStartDevDockers 
2. Start the tomcat server
3. See links section below to find the running system

(or similar for Alvin or DiVA)

## Links
(this is not fully working yet)
After starting the appropriate servers and containers from inside eclipse, the following will be exposed:

### SystemOne
[SystemOne web:http://localhost:8080/jsclient/theClient.html](http://localhost:8080/jsclient/theClient.html)<br>
[SystemOne REST:http://localhost:8080/therest/rest/](http://localhost:8080/therest/rest/)<br>
[Solr:http://localhost:8983/solr/](http://localhost:8983/solr/)<br>
[Karma:http://localhost:9876/](http://localhost:9876/)<br>

### Alvin
[Alvin web:http://localhost:8081/jsclient/theClient.html](http://localhost:8081/jsclient/theClient.html)<br>
[Alvin REST:http://localhost:8081/therest/rest/](http://localhost:8081/therest/rest/)<br>
[Solr:http://localhost:8984/solr/](http://localhost:8984/solr/)<br>

### DiVA
[DiVA web:http://localhost:8082/jsclient/theClient.html](http://localhost:8082/jsclient/theClient.html)<br>
[DiVA REST:http://localhost:8082/therest/rest/](http://localhost:8082/therest/rest/)<br>
[Solr:http://localhost:8984/solr/](http://localhost:8984/solr/)<br>


## Updating to a newer version of developed systems
1. Set your username in .gitconfig found in the root catalog where you installed the system, do this
from the host system as there currently seems to be some issue with setting information in the
file from the docker side of things.<br>
[user]<br>
        name = yourusername<br>
        email = user@organisation.org<br>
2. Go under External Tools Configurations (play icon with toolbox), run fetchAllFromLSU
3. Go under External Tools Configurations (play icon with toolbox), run mergeProjectsFromLSUMaster (confirm in console)
3. Go under External Tools Configurations (play icon with toolbox), run mvnPomCleanInstallAllButDocker
4. Go under External Tools Configurations (play icon with toolbox), run mvnPomCleanInstallDevDocker
5. Rightclick any project, and choose, maven / update project... (or F5) select all projects and run
6. Stop and start containers and tomcat servers.
