#! /bin/bash
ECLIPSEBRANCH=eclipsebranch

firstRun(){
	git clone https://github.com/olovm/cora-eclipse.git ~/workspace/cora-eclipse
	echo *** using cora-eclipse branch: $ECLIPSEBRANCH ***
	if [ $ECLIPSEBRANCH -eq 'master' ]; then
		echo *** checking out cora-eclipse branch: $ECLIPSEBRANCH ***
		cd ~/workspace/cora-eclipse
		git checkout $ECLIPSEBRANCH
		cd ~
	fi
		
	chmod +x ~/workspace/cora-eclipse/development/setupProjects.sh
	~/workspace/cora-eclipse/development/setupProjects.sh ~/workspace
	
	chmod +x ~/workspace/cora-eclipse/development/linkMetadata.sh
	~/workspace/cora-eclipse/development/linkMetadata.sh ~/workspace
	
	chmod +x ~/workspace/cora-eclipse/development/copyMetadata.sh
	~/workspace/cora-eclipse/development/copyMetadata.sh ~/workspace
	
	cd ~/workspace/cora-jsclient/
	npm install karma@latest karma-chrome-launcher@latest karma-firefox-launcher@latest karma-qunit@latest karma-coverage@latest karma-html-reporter@latest qunit@latest --save-dev

	runInstaller	
	
	chmod +x ~/workspace/cora-eclipse/development/postInstaller.sh
	~/workspace/cora-eclipse/development/postInstaller.sh ~/workspace
}

runInstaller(){
	#SWT_GTK3=0  ~/eclipse-installer/eclipse-inst
	~/eclipse-installer/eclipse-inst
}

if [ ! -d ~/workspace/cora-jsclient ]; then
  	firstRun
elif [ ! -d ~/eclipse/eclipseforcora ]; then
	runInstaller
else
	#SWT_GTK3=0 ~/eclipse/eclipseforcora/eclipse
	~/eclipse/eclipseforcora/eclipse
fi