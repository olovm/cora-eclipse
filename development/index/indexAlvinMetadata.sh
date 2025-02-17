#! /bin/bash

LOGIN_URL='http://localhost:8181/login/rest/apptoken/'
INDEX_URL='http://localhost:8081/alvin/rest/record/index'
LOGIN_ID='systemoneAdmin@system.cora.uu.se'
APP_TOKEN='5d3f3ed4-4931-4924-9faa-8eaf5ac6457e'

#index preview from outside
#LOGIN_URL='https://cora.alvin-portal.org/login/rest/apptoken/'
#INDEX_URL='https://cora.alvin-portal.org/rest/record/index'

#index dev from outside
#LOGIN_URL='http://130.238.171.238:38181/login/rest/apptoken/'
#INDEX_URL='http://130.238.171.238:38081/alvin/rest/record/index'

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
#	indexMetadata 'alvin-place';
#	indexMetadata 'alvin-person';
	logoutFromCora;
}

importBaseIndexScript() {
	.  ~/workspace/cora-eclipse/development/index/indexMetadataBaseScript.sh
}

################## calls start here #######################################
start
