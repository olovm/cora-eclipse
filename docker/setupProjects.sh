#! /bin/bash

if [ -z ${USER+x} ]; then 
	echo "USER is unset"; 
else 
	echo "USER is set to '$USER'"; 
	user=$USER
	export user
fi

importProjectListing() {
	#import projectListing
	.  ~/workspace/cora-eclipse/development/projectListing.sh
}

preventGitAskingForUsernameAndPasswordIfRepoIsMissing() {
	#prevent git asking for username password if repo is missing
	export GIT_ASKPASS="/bin/true"
}

addOtherRemotes(){
	local repositoryName=$1
	for otherRepoName in $otherRepos; do
		git remote add github-$otherRepo https://github.com/$otherRepoName/$repositoryName.git
	done
}

cloneRepoAndAddRemotes() {
	local repositoryName=$1
	cd /home/$user/workspace
	#git clone https://github.com/olovm/$repositoryName.git
	git clone $originRepo$repositoryName.git
	cd /home/$user/workspace/$repositoryName
	#git remote add github-lsu https://github.com/lsu-ub-uu/$repositoryName.git
	#git remote add github-maddekenn https://github.com/maddekenn/$repositoryName.git
	addOtherRemotes $repositoryName
	git fetch --all
	cd /home/$user/workspace
}

addAllRepositories() {
	for PROJECT in $ALL; do
		cloneRepoAndAddRemotes $PROJECT
	done
}

setBasePathToPointToBasicStorageWorkspaceDirectoryInTomcatContextXml(){
	sed -i "s|WORKSPACEDIR|/home/$user/workspace|g" "/home/$user/workspace/cora-eclipse/oomph/Servers/Tomcat v8.5 Server at localhost-config/context.xml"
}

chooseRepo(){
	echo ""
	echo "Please choose the remote you want to use as origin or enter a different one, "
	echo "where the cora projects have been cloned."
	echo "1. https://github.com/lsu-ub-uu/"
	echo "2. https://github.com/olovm/"
	echo "3. https://github.com/maddekenn/"
	echo "Choose 1, 2, 3 or enter your own base url to clone as origin. (eg. https://github.com/olovm/)"
	read -p "For origin, use? " userchoice
	case "$userchoice" in
	        1)
				echo "You choose: $userchoice 1111"
	            originRepo="https://github.com/lsu-ub-uu/"
	            otherRepos="olomv maddekenn"
	            ;;
	        2)
				echo "You choose: $userchoice 2222"
	            originRepo="https://github.com/olovm/"
	            otherRepos="lsu-ub-uu maddekenn"
	            ;;
	        3)
				echo "You choose: $userchoice 3333"
	            originRepo="https://github.com/maddekenn/"
	            otherRepos="lsu-ub-uu olomv"
	            ;;
	        *)
				echo "You choose: $userchoice other"
	            originRepo="$userchoice"
	            otherRepos="lsu-ub-uu olomv maddekenn"
	esac
	
	echo "Origin choosen as: $originRepo"
	echo "Others remotes will be: $otherRepos"
}

# ################# calls start here #######################################
chooseRepo
importProjectListing
preventGitAskingForUsernameAndPasswordIfRepoIsMissing
addAllRepositories
setBasePathToPointToBasicStorageWorkspaceDirectoryInTomcatContextXml
