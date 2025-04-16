#! /bin/bash

LOGIN_URL='http://localhost:8182/login/rest/apptoken/'
INDEX_URL='http://localhost:8082/diva/rest/record/index'
LOGIN_ID='systemoneAdmin@system.cora.uu.se'
APP_TOKEN='5d3f3ed4-4931-4924-9faa-8eaf5ac6457e'

#index def from outside
#LOGIN_URL='http://130.238.171.238:38182/login/rest/apptoken/'
#INDEX_URL='http://130.238.171.238:38082/diva/rest/record/index'

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
	
	indexMetadata 'diva-person';
	indexMetadata 'diva-organisation';
	indexMetadata 'diva-output';
	indexMetadata 'diva-funder';
	indexMetadata 'diva-publisher';
	indexMetadata 'diva-subject';
	indexMetadata 'diva-course';
	indexMetadata 'diva-project';
	indexMetadata 'diva-journal';
	indexMetadata 'diva-programme';
	indexMetadata 'diva-series';
	indexMetadata 'diva-localgenericmarkup';
	
	logoutFromCora;
}

importBaseIndexScript() {
	.  ~/workspace/cora-eclipse/development/index/indexMetadataBaseScript.sh
}

################## calls start here #######################################
start
