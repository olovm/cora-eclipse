#! /bin/bash

if [ -z ${USER+x} ]; then 
echo "USER is unset"; 
else 
echo "USER is set to '$USER'"; 
user=$USER
export user
fi


addRepro() {
	local name=$1
	cd /home/$user/workspace
	git clone https://github.com/olovm/$name.git
	cd /home/$user/workspace/$name
	git remote add github-lsu https://github.com/lsu-ub-uu/$name.git
	git fetch --all
	cd /home/$user/workspace
}


addRepro "cora-parent"

addRepro "cora-json"
addRepro "cora-httphandler"

addRepro "cora-bookkeeper"
addRepro "cora-beefeater"

addRepro "cora-fitnesse"

addRepro "cora-gatekeeperclient"
addRepro "cora-therest"
addRepro "cora-systemone"
addRepro "cora-gatekeeper"
addRepro "cora-userpicker"
addRepro "cora-spider"
addRepro "cora-jsclient"

addRepro "cora-basicstorage"
addRepro "cora-metacreator"
addRepro "cora-docker-therest"
addRepro "cora-docker-gatekeeper"

