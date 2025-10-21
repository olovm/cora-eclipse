#! /bin/bash

LOGIN_URL='http://localhost:8182/login/rest/apptoken/'
RUNNING_URL='http://localhost:8182/diva/rest/record/system'
RECORDTYPE_URL='http://localhost:8082/diva/rest/record/indexBatchJob'
LOGINID='systemoneAdmin@system.cora.uu.se'
APP_TOKEN='5d3f3ed4-4931-4924-9faa-8eaf5ac6457e'

#index def from outside
#LOGIN_URL='http://130.238.171.238:38182/login/rest/apptoken/'
#RUNNING_URL='http://130.238.171.238:38082/diva/rest/record/system'
#RECORDTYPE_URL='http://130.238.171.238:38082/diva/rest/record/indexBatchJob'

start(){
	importDeleteScript;
}

importDeleteScript() {
	.  ~/workspace/cora-eclipse/development/index/jobDeleteAllIndexBatchJobs.sh
}

################## calls start here #######################################
start
