#! /bin/bash

COLLECTEDERRORS=""

cleanInstall() {
	local name=$1
	echo "################### cleaning and installing $name  ###################"
	cd ~/workspace/$name/
	mvn clean install
	
	if [ $? -eq 0 ]
	then
		echo "################### done $name  ###################"
	else
		echo "################### failed $name  ###################">&2
		#exit 1
		COLLECTEDERRORS+=$name" "
	fi
}

#import projectListing
.  ~/workspace/cora-eclipse/development/projectListing.sh


#echo $ALL

for PROJECT in $DEV_DOCKER; do
#for PROJECT in $TIER1; do
	cleanInstall $PROJECT
done

if [ -n "$COLLECTEDERRORS" ]; then
	echo "Failed: "$COLLECTEDERRORS>&2
else
	echo "All OK!"
fi