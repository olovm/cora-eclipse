#! /bin/bash

#prevent git asking for username password if repo is missing
#export GIT_ASKPASS="/bin/true"
export GIT_TERMINAL_PROMPT=0

fetchAll() {
	local dir=$1
	echo $dir
	cd ~/workspace/$dir
#	git fetch --all
    git fetch --tags
    latesttag=$(git describe --tags `git rev-list --tags --max-count=1`)
	echo checking out ${latesttag}
	git checkout ${latesttag}
}

cd ~/workspace/

for i in $(find . -maxdepth 1 -type d)
do
    fetchAll "$i"
done
