#! /bin/bash


importProjectListing() {
	.  projectListing.sh
}

printProjects() {
	echo $ALL
}

loopProjectsNotInUse() {
    N=10;
	for PROJECT in $ALL; do
		((i=i%N)); ((i++==0)) && wait
		echo $PROJECT &
	done
        wait      # catch the processes that we did not wait for earlier
}

importProjectListing
printProjects