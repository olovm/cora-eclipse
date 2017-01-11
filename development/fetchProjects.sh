#! /bin/bash

#prevent git asking for username password if repo is missing
export GIT_ASKPASS="/bin/true"

fetchAll() {
	local dir=$1
	echo $dir
	cd ~/workspace/$dir
	git fetch --all
	#cd /home/$user/workspace
}

cd ~/workspace/

for i in $(find . -maxdepth 1 -type d)
do
    fetchAll "$i"
done
