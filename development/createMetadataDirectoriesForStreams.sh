#! /bin/bash

echo "Running createMetadataDirectories for streams ..."
workspaceDir=$1

start(){
	createMetadataDirectories;
}

createMetadataDirectories(){
	mkdir $workspaceDir/metadata/systemone -p
	mkdir $workspaceDir/metadata/alvin -p
	mkdir $workspaceDir/metadata/diva -p
}


# ################# calls start here #######################################
if [ ! $workspaceDir ]; then
  	echo "You must specify the workspace directory.."
else
	start
fi
