#! /bin/bash
declare branch=$1
declare skipProjects=$2

start() {
	printStartInfo
	importProjectListing
	preventGitFromAskingForPassword
	checkOutBranchForAllProjects
	echoOverwriteLastLine
}

printStartInfo() {
	echo 'Choosen branch:' $branch
	echo 'Skipping projects:' $skipProjects
	echo 'Looping through all projects looking for requested branch...'
}

importProjectListing() {
	#import projectListing
	.  ~/workspace/cora-eclipse/development/projectListing.sh
}

preventGitFromAskingForPassword() {
	#prevent git asking for username password if repo is missing
	#export GIT_ASKPASS="/bin/true"
	export GIT_TERMINAL_PROMPT=0
}

checkOutBranchForAllProjects() {
	local numberOfProjects=$(echo $ALL | wc -w)
	local numberOfChecked=0
	cd ~/workspace/
	for project in $ALL; do
		((numberOfChecked++))
		checkOutBranch $project $numberOfProjects $numberOfChecked
	done
}

checkOutBranch() {
	local project=$1
	local numberOfProjects=$2 
	local numberOfChecked=$3
	if [[ $skipProjects != *$project* ]]; then
		echoOverwriteLastLine "($numberOfChecked/$numberOfProjects) $project" 
		tryToCheckOutBranchForProject $project
	fi
}

echoOverwriteLastLine() { 
	echo -n -e "\r$@                                                       ";

#	echo -n -e "\r\033[1A\033[0K$@";
#	echo -n -e "\r\e[1A\e[0K$@";
#	echo -n -e "\r\033[43$@                                                       ";
#	echo -n -e "\r\e[43$@                                                       ";
#	echo -n -e "\r\x1b[43$@                                                       ";

#	echo -n -e "\r\u001B[32m$@                                                       ";
}

tryToCheckOutBranchForProject() {
	local project=$1
#	echo $project
	cd ~/workspace/$project
	git fetch origin $branch 2> /dev/null
	local fetchOk=$?
	if [ $fetchOk -eq 0 ]; then
		echoOverwriteLastLine
		echo
		echo $project
		echo checking out ${branch} for ${project}
		git checkout ${branch}
	fi
}


start