#! /bin/bash

#prevent git asking for username password if repo is missing
#export GIT_ASKPASS="/bin/true"
export GIT_TERMINAL_PROMPT=0

#import projectListing
.  ~/workspace/cora-eclipse/development/projectListing.sh




declare branch=$1
echo 'Choosen branch:' $branch
declare projects=$2
echo 'Choosen projects:' $projects

checkOutBranch() {
	local dir=$1
	echo $dir
	cd ~/workspace/$dir
	local fetchOk=$(git fetch origin $branch)
	echo $fetchOk
	echo checking out ${branch}
	git checkout ${branch}
}

cd ~/workspace/

#for i in $projects
#do
#    checkOutBranch "$i"
#done
#echo $ALL

for project in $ALL; do
#for PROJECT in $TIER1; do
	checkOutBranch $project
done