#! /bin/bash

start(){
	setUser;
	chooseRepo;
	importProjectListing;
	preventGitAskingForUsernameAndPasswordIfRepoIsMissing;
	addAllRepositories;
	setBasePathToPointToBasicStorageWorkspaceDirectoryInTomcatContextXml;
}

setUser(){
	if [ -z ${USER+x} ]; then 
		echo "USER is unset"; 
	else 
		echo "USER is set to '$USER'"; 
		user=$USER
		export user
	fi
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

importProjectListing() {
	#import projectListing
	.  ~/workspace/cora-eclipse/development/projectListing.sh
}

preventGitAskingForUsernameAndPasswordIfRepoIsMissing() {
	#prevent git asking for username password if repo is missing
	#export GIT_ASKPASS="/bin/true"
	GIT_TERMINAL_PROMPT=0
}

addAllRepositories() {
	for PROJECT in $ALL; do
		cloneRepoAndAddRemotes $PROJECT
	done
}

cloneRepoAndAddRemotes() {
	local projectName=$1
	
	setWorkingRepositoryAndProjectNameAsTemp
	echo "tempRepository:$tempRepository"
	echo "tempProjectName:$tempProjectName"
	
	cd /home/$user/workspace
	#echo "git clone $tempRepository$tempProjectName.git $projectName"
	git clone $tempRepository$tempProjectName.git $projectName
	cd /home/$user/workspace/$projectName
	addOtherRemotes $projectName
	git fetch --all
	cd /home/$user/workspace
}

setWorkingRepositoryAndProjectNameAsTemp(){
	tempProjectName=$projectName
	tempRepository=$originRepo

	if ! checkIfTempUrlExists; then 
		echo "- WARN - Chosen origin not found ($tempRepository$tempProjectName)"
		tryWithProjectNameWithoutCora
	fi
}

checkIfTempUrlExists(){
	local status=$(lookupUrl $tempRepository$tempProjectName)
	if [  $status -eq 200 ]; then 
		return 0
	fi
	false
}

lookupUrl(){
	local url=$1
	status=$(curl -s --head -w %{http_code} $url --connect-timeout 3 -o /dev/null)
	echo $status
}

tryWithProjectNameWithoutCora(){
	echo "Trying project name without cora..."
	tempProjectName=${projectName:5}

	if ! checkIfTempUrlExists; then 
		useLsuAsOrigin
	fi
}

useLsuAsOrigin(){
	echo "- WARN - Falling back to using lsu as origin";
	tempProjectName=$projectName
	tempRepository="https://github.com/lsu-ub-uu/"
}

addOtherRemotes(){
	local projectName=$1
	for otherRepoName in $otherRepos; do
		#echo "git remote add github-$otherRepoName https://github.com/$otherRepoName/$projectName.git"
		git remote add github-$otherRepoName https://github.com/$otherRepoName/$projectName.git
	done
}
	
setBasePathToPointToBasicStorageWorkspaceDirectoryInTomcatContextXml(){
	sed -i "s|WORKSPACEDIR|/home/$user/workspace|g" "/home/$user/workspace/cora-eclipse/oomph/Servers/Tomcat v8.5 Server at localhost-config/context.xml"
}

# ################# calls start here #######################################
start
