#! /bin/bash

RUNNING_URL='http://localhost:8080/systemone/rest/record/system'
#LOGIN_URL='http://localhost:8180/login/rest/apptoken/'
IDP_LOGIN_URL=http://localhost:8380/idplogin/
RECORDLIST_URL='http://localhost:8080/systemone/rest/record/indexBatchJob'
LOGINID='systemoneAdmin@system.cora.uu.se'
#APP_TOKEN='5d3f3ed4-4931-4924-9faa-8eaf5ac6457e'

#delete dev from outside
#RUNNING_URL='http://130.238.171.238:38080/systemone/rest/record/system'
#LOGIN_URL='http://130.238.171.238:38180/login/rest/apptoken/'
#RECORDLIST_URL='http://130.238.171.238:38080/systemone/rest/record/indexBatchJob'

start(){
	importDeleteScript;
}

importDeleteScript() {
#	.  ~/workspace/cora-eclipse/development/index/jobDeleteAllIndexBatchJobs.sh
	source "$(dirname "$0")/jobDeleteAllIndexBatchJobs.sh"
}

################## calls start here #######################################
start
