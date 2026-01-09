# cora-eclipse
Cora-eclipse is a project to enable easy setup of an Eclipse install for Cora development, using Eclipse and Docker.</br>
I am running this on linux so, change as needed for other platforms.

## Please note add serverRestUrl
The info is found under Finishing up, your first startup of the environment / point 7, in this document

## Temporary workaround for m2e-wtp not supporting java 25
**If you have used this workaround before can you remove it now**
The problem manifests itself by maven update projects does not find java 25 support, and deployment does not work as expected. To fix add the following to your m2/settings.xml file (in your active profile if you have one)
```xml
<properties>
	<java.release.version>24</java.release.version>
</properties>
```
## Before you begin
1. Make sure you have git and docker set up on your local machine
2. Make a directory where you want everything installed /x/y/z/cora (/mnt/depot/cora)
3. `cd /x/y/z/cora` to your new directory
4. Clone this repository: `git clone https://github.com/olovm/cora-eclipse.git`
5. (if problem with poping subwindows run "xhost +" on the host machine

if you need a different version of the dev environment than master, look under the heading:<br>
Starting dev environement cora-eclipse with different version than master

## Installing, runAll
The runAll script will take you through the entire process of setting up a docker based development environment for Cora. It will go through all needed steps. </br>
You can get your docker group id by running:
`getent group docker`

Run:</br>
`./cora-eclipse/runAll.sh dockerGroupId`</br>
**or run:**</br>
`./cora-eclipse/runAll.sh dockerGroupId master nocache`</br>
This option will do a pull of the base image, and not use the cache so that you get the latest version of the packages that gets installed from Fedora.

This scrip will, run the following headers automatically

### Build docker image
(Automatically run by runAll)<br>
This will take some time as it downloads quite a few things, eclipse, tomcat, etc

### Create directories on host 
(Automatically run by runAll)<br>
1. workspace (for your eclipse workspace)
2. eclipse (for your eclipse installation)
3. eclipseP2 (for files shared between multiple installations of eclipse)
4. m2 (for maven files)

### Docker first run installing eclipse
(Automatically run by runAll)<br>
When the container starts for the first time will it run the installation part of entrypoint.sh. This will
clone all Cora repositories, add other remotes to all of them, install needed npm karma in cora-jsclient and
start the eclipse installer (oomph). </br>

#### Cloning projects for Cora
You need to choose the remote you want to use as origin for cloning the Cora projects<br>
If you are uncertain use option **1. https://github.com/lsu-ub-uu/**

#### Eclipse installation
There are a few things that needs to be choosen in the installer<br>
First of all switch to **advanced mode** in the installer
 1. Browse for setup files for eclipse, **/home/yourUserName/workspace/cora-eclipse/oomph/EclipseForCora.setup** (use the plussign to add)
 2. Product version, set it to: **2025-12 Eclipse environment for Cora**
 3. Java 25+ VM, set it to: /usr/lib/jvm/**java-25-openjdk**
 
next step
 
 1. In next step browse for setup for projects, **/home/yourUserName/workspace/cora-eclipse/oomph/CoraProjects.setup** (use the plussign to add)
 2. Make sure **Cora projects** are marked

next step
 
 1. Choose installation location: **Installed in the specified absolute folder location**
 2. Fill in path for "Root install folder": set it to **/home/yourUserName/eclipse**
 3. Fill in path for "Installation location": set it to **/home/yourUserName/eclipse**
 4. Choose Workspace location rule: **Located in the absolute folder location**
 5. Fill in path for "Workspace location": **/home/yourUserName/workspace**
 6. Fill in path for "JRE 23 Location": **/usr/lib/jvm/java-25-openjdk**
 
next step<br>

finish
 
Saros might not allow you to log in, if so, skipp that step and do it later
<br>
This should get you through the installer and will eventually start eclipse and do a first run to setup eclipse. 
You can click on the spinning arrows, in the bottom of the screen to see what the setup does.
<br>
**Wait** for the setuptasks to finnish, no more spinning arrows, close eclipse, and then close the installer window. 
<br>
You are now ready to do a first startup of the environment. 

## if docker explorer do not show dockers
update the docker plugin through the marketplace<br>
(search for docker)


## Finishing up, your first startup of the environment
Start the environment by running:</br>
`./eclipse202512forcora1/startEclipseForCora.sh`
<br>
 **Do the following in the listed order to avoid problems!**
 1. Go in under preferences and make sure the latest java is choosen as default jre
 2. In project explorer, under the three little dots, deselect working sets
 3. Mark all projects and refresh them, menu or F5 (this will make sure eclipse sees files in target folders)
 4. Go under External Tools Configurations (play icon with toolbox), run mvnPomCleanInstallAllButDocker
 5. Go under External Tools Configurations (play icon with toolbox), run mvnPomCleanInstallDevDocker
 6. Rightclick any project, and choose, maven / update project... (or F5) select all projects and run
 7. For the main servers, systemone, alvin, diva open the server and under launch configuration / arguments / VM Arguments add the following:
 	**-DserverRestUrl=http://localhost:38080/systemone/rest/**
 	**-DserverRestUrl=http://localhost:38081/alvin/rest/**
 	**-DserverRestUrl=http://localhost:38082/diva/rest/**


### Start systemOne
1. Go under External Tools Configurations (play icon with toolbox) and start the development environment by running **systemoneStart**
2. When the script says waiting for local host, find the server tab and **start the tomcat servers for systemOne**
3. See links section below to find the running system

(or similar to run Alvin or DiVA)

## Links
After starting the appropriate servers and containers from inside eclipse, the following will be exposed on your host system:

### SystemOne
[SystemOne web:http://localhost:38080/jsclient/theClient.html](http://localhost:38080/jsclient/theClient.html)<br>
[Fitnesse:http://localhost:38090/fitnesse/FrontPage](http://localhost:38090/fitnesse/FrontPage)<br>
[SystemOne REST:http://localhost:38080/systemone/rest/](http://localhost:38080/systemone/rest/)<br>
[SystemOne Login:http://localhost:38180/login/rest/](http://localhost:38180/login/rest/)<br>
[SystemOne IdpLogin:http://localhost:38380/systemone/idplogin/login](http://localhost:38380/systemone/idplogin/login)<br>
[Solr:http://localhost:38983/solr/](http://localhost:38983/solr/)<br>
[RabbitMQ:http://localhost:15672/](http://localhost:15672/)guest/guest<br>
[Karma:http://localhost:39876/](http://localhost:39876/)<br>
[Fedora Commons:http://localhost:38087/fcrepo/](http://localhost:38087/fcrepo/)<br>
[IIF:http://localhost:38080/iif/](http://localhost:38080/iif/)<br>

### Alvin
[Alvin web:http://localhost:38081/jsclient/theClient.html](http://localhost:38081/jsclient/theClient.html)<br>
[Fitnesse:http://localhost:38091/fitnesse/FrontPage](http://localhost:38091/fitnesse/FrontPage)<br>
[Alvin REST:http://localhost:38081/alvin/rest/](http://localhost:38081/alvin/rest/)<br>
[Alvin Login:http://localhost:38181/login/rest/](http://localhost:38181/login/rest/)<br>
[Alvin IdpLogin:http://localhost:38381/alvin/idplogin/login](http://localhost:38381/alvin/idplogin/login)<br>
[Solr:http://localhost:38984/solr/](http://localhost:38984/solr/)<br>
[RabbitMQ:http://localhost:15673/](http://localhost:15673/)guest/guest<br>
[Fedora Commons:http://localhost:38088/fedora/](http://localhost:38088/fedora/)<br>
[IIF:http://localhost:38081/iif/](http://localhost:38081/iif/)<br>

### DiVA
[DiVA web:http://localhost:38082/jsclient/theClient.html](http://localhost:38082/jsclient/theClient.html)<br>
[Fitnesse:http://localhost:38092/fitnesse/FrontPage](http://localhost:38092/fitnesse/FrontPage)<br>
[DiVA REST:http://localhost:38082/diva/rest/](http://localhost:38082/diva/rest/)<br>
[DiVA Login:http://localhost:38182/login/rest/](http://localhost:38182/login/rest/)<br>
[DiVA IdpLogin:http://localhost:38382/diva/idplogin/login](http://localhost:38382/diva/idplogin/login)<br>
[Solr:http://localhost:38985/solr/](http://localhost:38985/solr/)<br>
[RabbitMQ:http://localhost:15674/](http://localhost:15674/)guest/guest<br>
[Fedora Commons:http://localhost:38089/fedora/](http://localhost:38089/fedora/)<br>
[IIF:http://localhost:38082/iif/](http://localhost:38082/iif/)<br>

## Commiting to github using token
### generate a github token
as described here:

https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token#creating-a-token

### push to git with token
username: your normal username
password: your token

## Starting dev environement of cora-eclipse with different version than master
1. cd to your eclipse install directory cd /x/y/z/cora/cora-eclipse
2. do a git pull: `git pull`
3. list remote branches: git ls-remote
4. checkout latest branch: `git checkout 201903_2`
5. cd up to cora directory: `cd ..`
6. run: `./cora-eclipse/runAll.sh 1001 201903_2`
7. continue with installation as normal

## Development

### Set your git info
Set your username in .gitconfig found in the root catalog where you installed the system, do this
from the host system as there currently seems to be some issue with setting information in the
file from the docker side of things.<br>
```bash
[user]
    name = yourusername
    email = user@organisation.org
```

### Updating to latest code from lsu repository
If you are working on in your own repository and want to update it with updates from lsu do the following<br>
1. Go under External Tools Configurations (play icon with toolbox), run **fetchAllFromLSU**
2. Go under External Tools Configurations (play icon with toolbox), run **mergeProjectsFromLSUMaster** (confirm in console)
3. Go under External Tools Configurations (play icon with toolbox), run **mvnPomCleanInstallAllButDocker**
4. Go under External Tools Configurations (play icon with toolbox), run **mvnPomCleanInstallDevDocker**
5. Rightclick any project, and choose, maven / update project... (or F5) select all projects and run
6. Stop and start containers and tomcat servers.

### Build all tags
1. Go under External Tools Configurations (play icon with toolbox) and run **checkOutLatestTagOfAllProjects**
2. Go under External Tools Configurations (play icon with toolbox) and run **mvnPomCleanInstallAllButDocker**
3. Go under External Tools Configurations (play icon with toolbox) and run **checkOutMasterOfAllProjects**

### Change all projects to a specific branch
1. Go under External Tools Configurations (play icon with toolbox) and run **checkOutAllProjectsThatHasBranch**<br>
2. Enter your desired branch such as: `issues/CORA-274`<br>
if you want to switch back all projects to master:<br>
Go under External Tools Configurations (play icon with toolbox) and run **checkOutMasterOfAllProjects**

### Change several projects to a specific branch
1. Go under External Tools Configurations (play icon with toolbox) and run **checkOutBranchForProjects**<br>
2. Enter your desired branch such as: `issues/CORA-274`
3. Enter a list of projects to switch: `"cora-gatekeeperserver cora-gatekeepertokenprovider"`<br>
if you want to switch back all projects to master:<br>
Go under External Tools Configurations (play icon with toolbox) and run **checkOutMasterOfAllProjects**

### Debugging FitNesse
Add the following to the top of the page, then use remoteDebugging such as DivaFitnesseDebug to connect to it when testing.
```
!path {java.class.path}
!define COMMAND_PATTERN {/usr/lib/jvm/java-25-openjdk/bin/java -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8000 -cp %p %m}
```

## Other
### For adding marketplace to oomph installer (note to self)
https://stackoverflow.com/questions/47582157/eclipse-marketplace-plug-ins-silent-install
Given a Marketplace install URL (https://marketplace.eclipse.org/marketplace-client-intro?mpc_install={ID}), construct the API URL as https://marketplace.eclipse.org/node/{ID}/api/p. Retrieve the XML file from that URL and look for the repository URL in the updateURL tag, and the available features in the ius tag. You'll need to append .feature.group to each IU feature listed

### Adding cert information for connection to Fedora Commons
For alvin server go into the launch configuration / arguments under VM arguments  add<br>
-Djavax.net.ssl.trustStore="/home/olov/workspace/cora-docker-fedora/files/fedoraKeystore.jks" -Djavax.net.ssl.trustStorePassword="changeit"

### exporting data from connected databases
connect to shell in devEnvironment:

`docker exec -it eclipse202512forcora1 bash `

to export data from running DiVA db run:
`pg_dump -U diva -h diva-cora-docker-postgresql -p 5432 -t organisation diva > ~/workspace/diva-cora-docker-postgresql/docker/data/exported.sql`


### Archive problem 
If problems with archive test for path not found:
enter docker:

`docker exec -it eclipse202512forcora1 bash`

go to your home dir:

`cd /home/yourUserName`

create needed dir in temp:

`mkdir /tmp/sharedArchiveReadable`

run archive readable:

`./archiveReadable.sh`

