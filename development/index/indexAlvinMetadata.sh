#! /bin/bash

LOGIN_URL='http://localhost:8181/login/rest/apptoken/'
RECORDTYPE_URL='http://localhost:8081/alvin/rest/record/recordType'
LOGINID='systemoneAdmin@system.cora.uu.se'
APP_TOKEN='5d3f3ed4-4931-4924-9faa-8eaf5ac6457e'

#index preview from outside
#LOGIN_URL='https://cora.alvin-portal.org/login/rest/apptoken/'
#RECORDTYPE_URL='https://cora.alvin-portal.org/rest/record/recordType'

#index dev from outside
#LOGIN_URL='http://130.238.171.238:38181/login/rest/apptoken/'
#RECORDTYPE_URL='http://130.238.171.238:38081/alvin/rest/record/recordType'

start(){
	importIndexScript;
}

importIndexScript() {
	.  ~/workspace/cora-eclipse/development/index/jobIndex.sh
}

################## calls start here #######################################
start
