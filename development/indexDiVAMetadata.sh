#! /bin/bash

#INDEX_URL='https://cora.epc.ub.uu.se/systemone/rest/record/index'
LOGIN_URL='http://localhost:8182/login/rest/apptoken/jsClientUser@system.cora.uu.se'
LOGOUT_URL='http://localhost:8182/login/rest/authToken/141414'
INDEX_URL='http://localhost:8082/diva/rest/record/index'
APP_TOKEN='5d3f3ed4-4931-4924-9faa-8eaf5ac6457e'

#index def from outside
#LOGIN_URL='http://130.238.171.238:38182/login/rest/apptoken/jsClientUser@system.cora.uu.se'
#LOGOUT_URL='http://130.238.171.238:38182/login/rest/authToken/141414'
#INDEX_URL='http://130.238.171.238:38082/diva/rest/record/index'
#APP_TOKEN='5d3f3ed4-4931-4924-9faa-8eaf5ac6457e'

start(){
	login;
	
	indexMetadata 'recordType';
	indexMetadata 'validationType';
	indexMetadata 'metadata';
	indexMetadata 'text';
	indexMetadata 'collectTerm';
	indexMetadata 'presentation';
	indexMetadata 'guiElement';
	indexMetadata 'system';
	
	indexMetadata 'person';
	indexMetadata 'organisation';
	indexMetadata 'divaOutput';
	indexMetadata 'nationalSubjectCategory';
	
	logoutFromCora;
}
login(){
	#AUTH_TOKEN=$(curl -s -X POST -k -i ${LOGIN_URL} --data ${APP_TOKEN} | grep -o -P '(?<={"name":"id","value":").*?(?="})')
	local loginAnswer=$(curl -s -X POST -H "Content-Type: text/plain" -k -i ${LOGIN_URL} --data ${APP_TOKEN});
	echo 'LoginAnswer: '${loginAnswer} 
	AUTH_TOKEN=$(echo ${loginAnswer} | grep -o -P '(?<={"name":"id","value":").*?(?="})')
	echo 'Logged in, got authToken: '${AUTH_TOKEN} 
}
indexMetadata(){
	echo ""
	local recordType=$1
	echo 'Indexing recordType: '${recordType}
	curl -s -X POST -k -H 'authToken: '${AUTH_TOKEN} -i ${INDEX_URL}'/'${recordType} | grep -o -P '(?<={"name":"id","value":").*?(?="})'
}
logoutFromCora(){
	echo ""
	curl -s -X DELETE -H "Content-Type: text/plain" -k  $LOGOUT_URL --data ${AUTH_TOKEN} 
	echo 'Logged out' 
}

# ################# calls start here #######################################
start
