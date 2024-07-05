#! /bin/bash

#INDEX_URL='https://cora.epc.ub.uu.se/systemone/rest/record/index'
LOGIN_URL='http://localhost:8181/login/rest/apptoken/141414'
LOGOUT_URL='http://localhost:8181/login/rest/authToken/141414'
INDEX_URL='http://localhost:8081/alvin/rest/record/index'
APP_TOKEN='63e6bd34-02a1-4c82-8001-158c104cae0e'

#index preview from outside
#LOGIN_URL='https://cora.alvin-portal.org/login/rest/apptoken/141414'
#LOGOUT_URL='https://cora.alvin-portal.org/login/rest/authToken/141414'
#INDEX_URL='https://cora.alvin-portal.org/rest/record/index'
#APP_TOKEN='63e6bd34-02a1-4c82-8001-158c104cae0e'

#index dev from outside
#LOGIN_URL='http://130.238.171.238:38181/login/rest/apptoken/141414'
#LOGOUT_URL='http://130.238.171.238:38181/login/rest/authToken/141414'
#INDEX_URL='http://130.238.171.238:38081/alvin/rest/record/index'
#APP_TOKEN='63e6bd34-02a1-4c82-8001-158c104cae0e'
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
#	indexMetadata 'alvin-place';
#	indexMetadata 'alvin-person';
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
	local indexAnswer=$(curl -s -X POST -k -H 'authToken: '${AUTH_TOKEN} -i ${INDEX_URL}'/'${recordType} )
	echo 'IndexAnswer: '${indexAnswer} 
#curl -s -X POST -k -H 'authToken: '9341f0bb-584a-492a-ae91-16169fa36bd0 -i https://cora.alvin-portal.org/alvin/rest/record/index/alvin-place 
}

logoutFromCora(){
	echo ""
	curl -s -X DELETE -H "Content-Type: text/plain" -k  $LOGOUT_URL --data ${AUTH_TOKEN} 
	echo 'Logged out' 
}

# ################# calls start here #######################################
start
