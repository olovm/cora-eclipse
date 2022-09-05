#! /bin/bash


importProjectListing() {
	.  projectListing.sh
}

printProjects() {
	echo $ALL
}

loopProjectsNotInUse() {
    N=10;
    local outString;
	for PROJECT in $ALL; do
		((i=i%N)); ((i++==0)) && wait
		#echo $PROJECT, &
		outString=$outString$PROJECT,
	done
        wait      # catch the processes that we did not wait for earlier
    echo $outString;
}

importProjectListing
#printProjects
loopProjectsNotInUse