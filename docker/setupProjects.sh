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


addRepro "cora-eclipse"

addRepro "cora-parent"

addRepro "cora-json"
addRepro "cora-httphandler"
addRepro "cora-userpicker"

addRepro "cora-beefeater"
addRepro "cora-bookkeeper"
addRepro "cora-gatekeeper"

addRepro "cora-spider"


addRepro "cora-basicstorage"
addRepro "cora-gatekeeperclient"
addRepro "cora-therest"

addRepro "cora-metacreator"
addRepro "cora-systemone"

addRepro "cora-jsclient"

addRepro "cora-fitnesse"

addRepro "cora-docker-gatekeeper"
addRepro "cora-docker-therest"
addRepro "cora-docker-fitnesse"
