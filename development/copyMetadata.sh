#! /bin/bash

echo "Running copyMetadata..."
workspaceDir=$1

start(){
	copyMetadata;
}


copyMetadata(){
	copyMetadataToSystemOne;
	copyMetadataToAlvin;	
	copyMetadataToDiVA;
}

copyMetadataToSystemOne(){
	#systemOne currently has no copied data, main data updated from systemOne
}

copyMetadataToAlvin(){
#TODO: clear out previous files before copy
	cp $workspaceDir/cora-metadata/files/cora $workspaceDir/metadata/alvin/cora
	cp $workspaceDir/cora-metadata/files/jsClient $workspaceDir/metadata/alvin/jsClient
#	cp $workspaceDir/alvin-metadata/files/alvin $workspaceDir/metadata/alvin/alvin
#	cp $workspaceDir/alvin-metadata/files/bibsys $workspaceDir/metadata/alvin/bibsys
#temporaraly copy in  systemone
	cp $workspaceDir/systemone-metadata/files/systemOne $workspaceDir/metadata/alvin/systemOne
}

copyMetadataToDiVA(){
#TODO: clear out previous files before copy
	cp $workspaceDir/cora-metadata/files/cora $workspaceDir/metadata/diva/cora
	cp $workspaceDir/cora-metadata/files/jsClient $workspaceDir/metadata/diva/jsClient
#	cp $workspaceDir/diva-metadata/files/diva $workspaceDir/metadata/diva/diva
#	cp $workspaceDir/diva-metadata/files/bibsys $workspaceDir/metadata/diva/bibsys
#temporaraly copy in systemOne
	cp $workspaceDir/systemone-metadata/files/systemOne $workspaceDir/metadata/diva/systemOne
}

# ################# calls start here #######################################
if [ ! $workspaceDir ]; then
  	echo "You must specify the workspace directory.."
else
	start
fi
