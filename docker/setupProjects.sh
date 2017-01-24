#! /bin/bash

if [ -z ${USER+x} ]; then 
	echo "USER is unset"; 
else 
	echo "USER is set to '$USER'"; 
	user=$USER
	export user
fi

#prevent git asking for username password if repo is missing
export GIT_ASKPASS="/bin/true"


addRepro() {
	local name=$1
	cd /home/$user/workspace
	git clone https://github.com/olovm/$name.git
	cd /home/$user/workspace/$name
	git remote add github-lsu https://github.com/lsu-ub-uu/$name.git
	git remote add github-maddekenn https://github.com/maddekenn/$name.git
	git fetch --all
	cd /home/$user/workspace
}

setBasePathToPointToBasicStorageWorkspaceDirectory(){
	sed -i "s|WORKSPACEDIR|/home/$user/workspace|g" "/home/$user/workspace/cora-eclipse/oomph/Servers/Tomcat v8.5 Server at localhost-config/context.xml"
}

addRepro "cora-eclipse"
setBasePathToPointToBasicStorageWorkspaceDirectory

#TIER0
addRepro "cora-parent"

#TIER1
addRepro "cora-json"
addRepro "cora-httphandler"
addRepro "cora-userpicker"

#TIER2
addRepro "cora-beefeater"
addRepro "cora-bookkeeper"
addRepro "cora-gatekeeper"

#TIER3
addRepro "cora-spider"
addRepro "cora-gatekeepertokenprovider"


#TIER4
addRepro "cora-basicstorage"
addRepro "cora-gatekeeperclient"
addRepro "cora-therest"
addRepro "cora-apptokenverifier"

#TIER5
addRepro "cora-metacreator"
addRepro "cora-systemone"

#TIER6
addRepro "cora-jsclient"
addRepro "cora-fitnesse"


addRepro "cora-docker-gatekeeper"
addRepro "cora-docker-therest"
addRepro "cora-docker-fitnesse"
