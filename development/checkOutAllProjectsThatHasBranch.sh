#! /bin/bash
declare branch=$1
declare skipProjects=$2

start() {
	printStartInfo
	importProjectListing
	preventGitFromAskingForPassword
	checkOutBranchForAllProjects
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
	cd ~/workspace/
	for project in $ALL; do
		checkOutBranch $project
	done
}

checkOutBranch() {
	local project=$1
	if [[ $skipProjects != *$project* ]]; then
		tryToCheckOutBranchForProject $project
	fi
}

tryToCheckOutBranchForProject() {
	local project=$1
#	echo $project
	cd ~/workspace/$project
	git fetch origin $branch 2> /dev/null
	local fetchOk=$?
	if [ $fetchOk -eq 0 ]; then
		echo
		echo checking out ${branch} for ${project}
		git checkout ${branch}
	fi
}


start