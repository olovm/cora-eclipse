#! /bin/bash

#prevent git asking for username password if repo is missing
#export GIT_ASKPASS="/bin/true"
export GIT_TERMINAL_PROMPT=0

fetchAll() {
	local dir=$1
	echo $dir
	cd ~/workspace/$dir
	git fetch --all
}

cd ~/workspace/

N=10;
for d in $(find . -maxdepth 1 -type d)
do
		((i=i%N)); ((i++==0)) && wait
    	fetchAll "$d" &
done
        # catch the processes that we did not wait for earlier
        wait
