#! /bin/bash

#prevent git asking for username password if repo is missing
#export GIT_ASKPASS="/bin/true"
export GIT_TERMINAL_PROMPT=0

declare branch=$1
echo 'Choosen branch:' $branch
declare projects=$2
echo 'Choosen projects:' $projects

checkOutBranch() {
	local dir=$1
	echo $dir
	cd ~/workspace/$dir
	git fetch origin $branch
	echo checking out ${branch}
	git checkout ${branch}
}

cd ~/workspace/

for i in $projects
do
    checkOutBranch "$i"
done