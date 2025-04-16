#! /bin/bash

LOGIN_URL='http://localhost:8180/login/rest/apptoken/'
INDEX_URL='http://localhost:8080/systemone/rest/record/index'
LOGIN_ID='systemoneAdmin@system.cora.uu.se'
APP_TOKEN='5d3f3ed4-4931-4924-9faa-8eaf5ac6457e'

#index dev from outside
#LOGIN_URL='http://130.238.171.238:38180/login/rest/apptoken/'
#INDEX_URL='http://130.238.171.238:38080/systemone/rest/record/index'

start(){
	importBaseIndexScript;
	login;
	indexMetadata 'recordType';
	indexMetadata 'validationType';
	indexMetadata 'permissionUnit';
	indexMetadata 'metadata';
	indexMetadata 'text';
	indexMetadata 'collectTerm';
	indexMetadata 'presentation';
	indexMetadata 'guiElement';
	indexMetadata 'system';
	
	indexMetadata 'demo';
	indexMetadata 'example';
	
	logoutFromCora;
}

importBaseIndexScript() {
	.  ~/workspace/cora-eclipse/development/index/indexMetadataBaseScript.sh
}

################## calls start here #######################################
start
