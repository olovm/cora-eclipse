#! /bin/bash
ECLIPSEBRANCH=$eclipsebranch
echo "running entrypoint.sh..."
echo "*** using cora-eclipse branch: $ECLIPSEBRANCH ***"

firstRun(){
	cloneCoraEclipseProject
	possiblyCheckoutOtherBranchThanMaster	
	setupProjects	
	createMetadataDirectoriesForStreams
	runKarmaInstall
	runInstaller
	copySarosToDropin	
}

cloneCoraEclipseProject(){
	git clone https://github.com/olovm/cora-eclipse.git ~/workspace/cora-eclipse
}

possiblyCheckoutOtherBranchThanMaster(){
	if [ $ECLIPSEBRANCH != 'master' ]; then
		echo "*** checking out cora-eclipse branch: $ECLIPSEBRANCH ***"
		cd ~/workspace/cora-eclipse
		git checkout $ECLIPSEBRANCH
		cd ~
	fi
}

setupProjects(){
	chmod +x ~/workspace/cora-eclipse/docker/setupProjects.sh
	~/workspace/cora-eclipse/docker/setupProjects.sh ~/workspace
}

createMetadataDirectoriesForStreams(){
	chmod +x ~/workspace/cora-eclipse/docker/createMetadataDirectoriesForStreams.sh
	~/workspace/cora-eclipse/docker/createMetadataDirectoriesForStreams.sh ~/workspace
}

runKarmaInstall(){
	cd ~/workspace/cora-jsclient/
	npm cache clean --force
	npm install karma@latest karma-chrome-launcher@latest karma-firefox-launcher@latest karma-qunit@latest karma-coverage@latest karma-html-reporter@latest qunit@latest --save-dev
}

runInstaller(){
	cd ~/workspace/cora-eclipse/oomph
	#SWT_GTK3=0  ~/eclipse-installer/eclipse-inst
	~/eclipse-installer/eclipse-inst
}

copySarosToDropin(){
	cp ~/workspace/cora-eclipse/docker/sarosDropin/features/ ~/eclipse/eclipseforcora/dropins/ -R
	cp ~/workspace/cora-eclipse/docker/sarosDropin/plugins/ ~/eclipse/eclipseforcora/dropins/ -R
}

if [ ! -d ~/workspace/cora-jsclient ]; then
  	firstRun
elif [ ! -d ~/eclipse/eclipseforcora ]; then
	runInstaller
else
	#SWT_GTK3=0 ~/eclipse/eclipseforcora/eclipse
	~/archiveReadable.sh
	~/eclipse/eclipseforcora/eclipse
fi