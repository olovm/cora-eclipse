#! /usr/bin/env bash
userChoosenGroup=$1;

start(){
	importProjectListing;
	PROJECTS_TO_RUN="${!userChoosenGroup}";
	checkChoosenProjectsExists;
	createTempPomFile;
	buildParentSeparatelyFirstAsMavenNeedsItForBuilding;
	cleanInstallAllUsingTempPomFile;	
}

importProjectListing(){
	.  ~/workspace/cora-eclipse/development/projectListing.sh
}

checkChoosenProjectsExists(){
	if [  ${#PROJECTS_TO_RUN} -lt 1 ]; then 
		echo "Error, choosen group ($userChoosenGroup) does not exist in projectListings.sh."
		exit 1;
	fi
}

createTempPomFile(){
	copyTempPomFileToWorkspace;
	addAllProjectsToTempPomFile;
	writeEndToTempPomFile;
}

copyTempPomFileToWorkspace(){
	touch ~/workspace/tempPom.xml
	cp ~/workspace/cora-eclipse/development/modulePomTemplate.xml ~/workspace/tempPom.xml
}

addAllProjectsToTempPomFile(){
	for PROJECT in $PROJECTS_TO_RUN; do
		echo "adding project $PROJECT"
		echo "<module>$PROJECT</module>" >>  ~/workspace/tempPom.xml
	done
}

writeEndToTempPomFile(){
		echo "</modules>" >>  ~/workspace/tempPom.xml
		echo "</project>" >>  ~/workspace/tempPom.xml
}

buildParentSeparatelyFirstAsMavenNeedsItForBuilding(){
	mvn -f ~/workspace/cora-parent/pom.xml clean install
}

cleanInstallAllUsingTempPomFile(){
	mvn -T 1.5C -f ~/workspace/tempPom.xml clean install
}	

# ################# calls start here #######################################
start;
