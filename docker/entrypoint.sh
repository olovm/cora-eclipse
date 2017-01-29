#! /bin/bash

firstRun(){
	git clone https://github.com/olovm/cora-eclipse.git ~/workspace/cora-eclipse
	
	chmod +x ~/workspace/cora-eclipse/development/setupProjects.sh
	~/workspace/cora-eclipse/development/setupProjects.sh "~/workspace"
	
	cd ~/workspace/cora-jsclient/
	npm install karma karma-chrome-launcher karma-firefox-launcher karma-qunit karma-coverage karma-html-reporter qunitjs --save-dev
	
	#SWT_GTK3=0  ~/eclipse-installer/eclipse-inst
	~/eclipse-installer/eclipse-inst
}


if [ ! -d ~/workspace/cora-jsclient ]; then
  	firstRun
else
	SWT_GTK3=0 ~/eclipse/eclipseforcora/eclipse
fi