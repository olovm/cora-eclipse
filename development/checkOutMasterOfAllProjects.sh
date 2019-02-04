#! /bin/bash

#prevent git asking for username password if repo is missing
#export GIT_ASKPASS="/bin/true"
export GIT_TERMINAL_PROMPT=0

fetchAll() {
	local dir=$1
	echo $dir
	cd ~/workspace/$dir
	echo checking out master
	git checkout master
}

cd ~/workspace/

for i in $(find . -maxdepth 1 -type d)
do
    fetchAll "$i"
done
