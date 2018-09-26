#! /bin/bash

echo "Running linkMetadata..."
workspaceDir=$1

start(){
	createMetadataDirectories;
	linkMetadata;
}

createMetadataDirectories(){
	mkdir $workspaceDir/metadata/systemone -p
	mkdir $workspaceDir/metadata/alvin -p
	mkdir $workspaceDir/metadata/diva -p
}
linkMetadata(){
	ln -s $workspaceDir/cora-metadata/files/cora $workspaceDir/metadata/systemone/cora
	ln -s $workspaceDir/cora-metadata/files/jsClient $workspaceDir/metadata/systemone/jsClient
	ln -s $workspaceDir/cora-metadata/files/testSystem $workspaceDir/metadata/systemone/testSystem
	ln -s $workspaceDir/systemone-metadata/files/systemOne $workspaceDir/metadata/systemone/systemOne
	
	ln -s $workspaceDir/cora-metadata/files/cora $workspaceDir/metadata/alvin/cora
	ln -s $workspaceDir/cora-metadata/files/jsClient $workspaceDir/metadata/alvin/jsClient
	ln -s $workspaceDir/alvin-metadata/files/alvin $workspaceDir/metadata/alvin/alvin
	ln -s $workspaceDir/alvin-metadata/files/bibsys $workspaceDir/metadata/alvin/bibsys
#temporaraly link in  systemone
	ln -s $workspaceDir/systemone-metadata/files/systemOne $workspaceDir/metadata/alvin/systemOne
	#ln -s /home/olov/workspace/systemone-metadata/files/systemOne /home/olov/workspace/metadata/alvin/systemOne
	#ln -s /home/olov/workspace/systemone-metadata/files/systemOne /home/olov/workspace/metadata/diva/systemOne
	
	ln -s $workspaceDir/cora-metadata/files/cora $workspaceDir/metadata/diva/cora
	ln -s $workspaceDir/cora-metadata/files/jsClient $workspaceDir/metadata/diva/jsClient
	ln -s $workspaceDir/diva-metadata/files/diva $workspaceDir/metadata/diva/diva
	ln -s $workspaceDir/diva-metadata/files/bibsys $workspaceDir/metadata/diva/bibsys
#temporaraly link in systemOne
	ln -s $workspaceDir/systemone-metadata/files/systemOne $workspaceDir/metadata/diva/systemOne
}
# ################# calls start here #######################################
if [ ! $workspaceDir ]; then
  	echo "You must specify the workspace directory.."
else
	start
fi
