#! /bin/bash

RUNNING_URL='http://localhost:8082/diva/rest/record/system'
#LOGIN_URL='http://localhost:8182/login/rest/apptoken/'
RECORDTYPE_URL='http://localhost:8082/diva/rest/record/recordType'
LOGINID='systemoneAdmin@system.cora.uu.se'
#APP_TOKEN='5d3f3ed4-4931-4924-9faa-8eaf5ac6457e'

IDP_LOGIN_URL='http://localhost:8382/idplogin/'

#index def from outside
#LOGIN_URL='http://130.238.171.238:38182/login/rest/apptoken/'
#RECORDTYPE_URL='http://130.238.171.238:38082/diva/rest/record/recordType'

start(){
	importIndexScript;
}

importIndexScript() {
	.  ~/workspace/cora-eclipse/development/index/jobIndex.sh
}

################## calls start here #######################################
start
