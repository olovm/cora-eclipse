# cora-eclipse
Cora-eclipse is a project to enable easy setup of an Eclipse install for Cora development, using Eclipse and Docker.</br>
I am running this on linux so, change as needed for other platforms.

## Before you begin
1. Make sure you have git and docker set up on your local machine
2. Make a directory where you want everything installed /x/y/z/cora (/mnt/depot/cora)
3. cd to your new directory
3. Clone this repository: `git clone https://github.com/olovm/cora-eclipse.git`



## Installing, runAll
The runAll script will take you through the entire process of setting up a docker based development environment for Cora. It will go through all needed steps. </br>
You can get your docker group id by running;
`getent group docker`

Run:</br>
`./cora-eclipse/runAll.sh dockerGroupId`</br>
**or run:**</br>
`./cora-eclipse/runAll.sh dockerGroupId master nocache`</br>
This option will do a pull of the base image, and not use the cache so that you get the latest version of the packages that gets installed from Fedora.

This scrip will, run the following headers automatically

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

 1. You need to use the advanced mode 
 
 1. Browse for setup files for eclipse, /home/yourUserName/workspace/cora-eclipse/oomph/EclipseForCora.setup (use the plussign to add)
 2. Java 11+ VM, set it to: /usr/lib/jvm/java-15-openjdk
 
 next step
 
 1. In next step browse for setup for projects, /home/yourUserName/workspace/cora-eclipse/oomph/CoraProjects.setup (use the plussign to add)
 2. Make sure "Cora projects" are marked

 next step
 
 1. Choose installation location: "Installed in the specified absolute folder location"
 2. Fill in path for "Root install folder": set it to /home/yourUserName/eclipse
 6. Fill in path for "Installation location": set it to /home/yourUserName/eclipse
 5. Choose Workspace location rule: "Located in the absolute folder location"
 6. Fill in path for "Workspace location": /home/yourUserName/workspace
 7. Fill in path for "JRE 13 Location": /usr/lib/jvm/java-15-openjdk
 
 next step
 
 finnish
 
 saros might not allow you to log in, if so, skipp that step and do it later
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
 1. Go in under preferences and make sure the latest java is choosen as default jre
 2. In project explorer, under the three little dots, deselect working sets
 3. Mark all projects and refresh them, menu or F5 (this will make sure eclipse sees files in target folders)
 4. Start and stop the servers (in server tab) in the following order:
    1. Tomcat v9.0 systemOne
    2. Tomcat v9.0 alvin
    3. Tomcat v9.0 diva
 5. Go under External Tools Configurations (play icon with toolbox) and run linkJsClientToTomcats
 6. Go under External Tools Configurations (play icon with toolbox) and run copyMetadata


### Start systemOne
1. Go under External Tools Configurations (play icon with toolbox) and start the docker containers for development by running systemoneStartDevDockers 
2. Start fitnesse, Go under Run Configurations (play icon) and start fitnesse
2. Start the tomcat servers for systemOne
3. See links section below to find the running system

(or similar for Alvin or DiVA)

## Links
After starting the appropriate servers and containers from inside eclipse, the following will be exposed:

### SystemOne
[SystemOne web:http://localhost:8080/jsclient/theClient.html](http://localhost:8080/jsclient/theClient.html)<br>
[Fitnesse:http://localhost:8090/fitnesse/FrontPage](http://localhost:8090/fitnesse/FrontPage)<br>
[SystemOne REST:http://localhost:8080/therest/rest/](http://localhost:8080/systemone/rest/)<br>
[Solr:http://localhost:8983/solr/](http://localhost:8983/solr/)<br>
[Karma:http://localhost:9876/](http://localhost:9876/)<br>

### Alvin
[Alvin web:http://localhost:8081/jsclient/theClient.html](http://localhost:8081/jsclient/theClient.html)<br>
[Fitnesse:http://localhost:8091/fitnesse/FrontPage](http://localhost:8091/fitnesse/FrontPage)<br>
[Alvin REST:http://localhost:8081/therest/rest/](http://localhost:8081/therest/rest/)<br>
[Solr:http://localhost:8984/solr/](http://localhost:8984/solr/)<br>
[Fedora Commons:http://localhost:8089/fedora/](http://localhost:8089/fedora/)<br>

### DiVA
[DiVA web:http://localhost:8082/jsclient/theClient.html](http://localhost:8082/jsclient/theClient.html)<br>
[Fitnesse:http://localhost:8092/fitnesse/FrontPage](http://localhost:8092/fitnesse/FrontPage)<br>
[DiVA REST:http://localhost:8082/therest/rest/](http://localhost:8082/therest/rest/)<br>
[Solr:http://localhost:8984/solr/](http://localhost:8984/solr/)<br>

# Updating

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

### Updating with a new non master version of eclipse dev environment
1. cd to your eclipse install directory cd /x/y/z/cora/cora-eclipse
2. do a git pull: git pull
3. list remote branches: git ls-remote
4. checkout latest branch: git checkout 201903_2
5. cd up to cora directory: cd ..
6. run: ./cora-eclipse/runAll.sh 1001 201903_2
7. continue with installation

# Other

### Adding cert information for connection to Fedora Commons
For alvin server go into the launch configuration / arguments under VM arguments  add<br>
-Djavax.net.ssl.trustStore="/home/olov/workspace/cora-docker-fedora/files/fedoraKeystore.jks" -Djavax.net.ssl.trustStorePassword="changeit"


### Build all tags
1. Go under External Tools Configurations (play icon with toolbox) and run checkOutLatestTagOfAllProjects
2. Go under External Tools Configurations (play icon with toolbox) and run mvnPomCleanInstallAllButDocker 
3. Go under External Tools Configurations (play icon with toolbox) and run checkOutMasterOfAllProjects

### For adding marketplace to oomph installer (note to self)
https://stackoverflow.com/questions/47582157/eclipse-marketplace-plug-ins-silent-install
Given a Marketplace install URL (https://marketplace.eclipse.org/marketplace-client-intro?mpc_install={ID}), construct the API URL as https://marketplace.eclipse.org/node/{ID}/api/p. Retrieve the XML file from that URL and look for the repository URL in the updateURL tag, and the available features in the ius tag. You'll need to append .feature.group to each IU feature listed

### exporting data from connected databases
connect to shell in devEnvironment:

docker exec -it eclipse202012forcora1 bash 

to export data from running DiVA db run:
pg_dump -U diva -h diva-cora-docker-postgresql -p 5432 -t organisation diva > ~/workspace/diva-cora-docker-postgresql/docker/data/exported.sql