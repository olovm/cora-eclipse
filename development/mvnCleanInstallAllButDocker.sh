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

TIER0="cora-parent"
TIER1="cora-json cora-httphandler cora-userpicker "
TIER2="cora-beefeater cora-bookkeeper cora-gatekeeper "
TIER3="cora-spider cora-gatekeepertokenprovider"
TIER4="cora-basicstorage cora-gatekeeperclient cora-therest cora-apptokenverifier "
TIER5="cora-metacreator cora-systemone "
#TIER6="cora-jsclient cora-fitnesse "
TIER6="cora-fitnesse "

ALL=$TIER0" "$TIER1" "$TIER2" "$TIER3" "$TIER4" "$TIER5" "$TIER6

#echo $ALL

for PROJECT in $ALL; do
	cleanInstall $PROJECT
done

if [ -n "$COLLECTEDERRORS" ]; then
	echo "Failed: "$COLLECTEDERRORS>&2
else
	echo "All OK!"
fi