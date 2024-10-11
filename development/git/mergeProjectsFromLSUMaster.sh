#! /bin/bash

#prevent git asking for username password if repo is missing
#export GIT_ASKPASS="/bin/true"
export GIT_TERMINAL_PROMPT=0

start(){
	confirmMerge
}

confirmMerge(){
	echo ""
	echo "Are you sure you want to merge all fetched data from LSU master to all of your projects? "
	echo "y/N"
	read -p "I am sure? " userchoice
	case "$userchoice" in
	        y)
				echo "You choose: YES"
				loopDirectoriesAndFetch;
	            ;;
	        *)
				echo "You choose: NO"
	esac
}

loopDirectoriesAndFetch(){
	cd ~/workspace/
	
	for i in $(find . -maxdepth 1 -type d)
	do
	    fetchAll "$i"
	done
}

fetchAll() {
	local dir=$1
	echo $dir
	cd ~/workspace/$dir
	git merge github-lsu-ub-uu/master
}

## call starts here ##
start
