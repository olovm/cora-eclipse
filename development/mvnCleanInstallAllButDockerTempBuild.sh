#! /bin/bash

COLLECTEDERRORS=""

cleanInstall() {
	local name=$1
	echo "################### cleaning and installing $name  ###################"
	cd /mnt/depot/eclipseNeon3/eclipseForCora/workspace/$name/
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

##import projectListing
#. /mnt/depot/eclipseNeon3/eclipseForCora/workspace/cora-eclipse/development/projectListing.sh
#
##echo $ALL
#
#for PROJECT in $ALL_JAVA; do
##for PROJECT in $TIER1; do
#	cleanInstall $PROJECT
#done

cleanInstall "cora-solrsearch";
cleanInstall "cora-systemone";
cleanInstall "cora-docker-therest";
cleanInstall "cora-docker-fitnesse";

docker stop fitnesse therest;
docker rm fitnesse therest;
docker run --net=cora --volumes-from gatekeeper -p 8083:8080 --name therest --link gatekeeper:gatekeeper --link solr:solr -d  therest;
docker run --net=cora -p 8091:8090 --name fitnesse --link therest:therest --link apptokenverifier:apptokenverifier -d fitnesse;

if [ -n "$COLLECTEDERRORS" ]; then
	echo "Failed: "$COLLECTEDERRORS>&2
else
	echo "All OK!"
fi