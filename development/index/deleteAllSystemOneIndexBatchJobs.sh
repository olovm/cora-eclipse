#! /bin/bash

LOGIN_URL='http://localhost:8180/login/rest/apptoken/'
RUNNING_URL='http://localhost:8080/systemone/rest/record/system'
RECORDLIST_URL='http://localhost:8080/systemone/rest/record/indexBatchJob'
LOGINID='systemoneAdmin@system.cora.uu.se'
APP_TOKEN='5d3f3ed4-4931-4924-9faa-8eaf5ac6457e'

#delete dev from outside
#LOGIN_URL='http://130.238.171.238:38180/login/rest/apptoken/'
#RECORDLIST_URL='http://130.238.171.238:38080/systemone/rest/record/indexBatchJob'

start(){
	importDeleteScript;
}

importDeleteScript() {
	.  ~/workspace/cora-eclipse/development/index/jobDeleteAllIndexBatchJobs.sh
}

################## calls start here #######################################
start
