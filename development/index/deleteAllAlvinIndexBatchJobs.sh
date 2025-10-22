#! /bin/bash

LOGIN_URL='http://localhost:8181/login/rest/apptoken/'
RUNNING_URL='http://localhost:8081/alvin/rest/record/system'
RECORDLIST_URL='http://localhost:8081/alvin/rest/record/indexBatchJob'
LOGINID='systemoneAdmin@system.cora.uu.se'
APP_TOKEN='5d3f3ed4-4931-4924-9faa-8eaf5ac6457e'

#index preview from outside
#LOGIN_URL='https://cora.alvin-portal.org/login/rest/apptoken/'
#RUNNING_URL='https://cora.alvin-portal.org/rest/record/system'
#RECORDLIST_URL='https://cora.alvin-portal.org/rest/record/indexBatchJob'

#index dev from outside
#LOGIN_URL='http://130.238.171.238:38181/login/rest/apptoken/'
#RUNNING_URL='http://130.238.171.238:38081/alvin/rest/record/system'
#RECORDLIST_URL='http://130.238.171.238:38081/alvin/rest/record/indexBatchJob'

#local minkube alvin http://192.168.49.2:30981
#LOGIN_URL='http://192.168.49.2:30981/login/rest/apptoken/'
#RUNNING_URL='http://192.168.49.2:30981/rest/record/system'
#RECORDLIST_URL='http://192.168.49.2:30981/rest/record/indexBatchJob'


start(){
	importDeleteScript;
}

importDeleteScript() {
	.  ~/workspace/cora-eclipse/development/index/jobDeleteAllIndexBatchJobs.sh
#	.  jobDeleteAllIndexBatchJobs.sh
}

################## calls start here #######################################
start
