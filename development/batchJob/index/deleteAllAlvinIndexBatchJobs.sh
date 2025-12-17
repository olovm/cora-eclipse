#! /bin/bash

RUNNING_URL='http://localhost:8081/alvin/rest/record/system'
#LOGIN_URL='http://localhost:8181/login/rest/apptoken/'
IDP_LOGIN_URL=http://localhost:8381/idplogin/
RECORDLIST_URL='http://localhost:8081/alvin/rest/record/indexBatchJob'
LOGINID='systemoneAdmin@system.cora.uu.se'
#APP_TOKEN='5d3f3ed4-4931-4924-9faa-8eaf5ac6457e'

#index dev from outside
#RUNNING_URL='http://130.238.171.238:38081/alvin/rest/record/system'
#LOGIN_URL='http://130.238.171.238:38181/login/rest/apptoken/'
#RECORDLIST_URL='http://130.238.171.238:38081/alvin/rest/record/indexBatchJob'

#index preview from outside
#LOGIN_URL='https://cora.alvin-portal.org/login/rest/apptoken/'
#RUNNING_URL='https://cora.alvin-portal.org/rest/record/system'
#RECORDLIST_URL='https://cora.alvin-portal.org/rest/record/indexBatchJob'


#local minkube alvin http://192.168.49.2:30981
#LOGIN_URL='http://192.168.49.2:30981/login/rest/apptoken/'
#RUNNING_URL='http://192.168.49.2:30981/rest/record/system'
#RECORDLIST_URL='http://192.168.49.2:30981/rest/record/indexBatchJob'

#pre k8s alvin https://alvin.pre.test.ub.uu.se
#RUNNING_URL='https://alvin.pre.test.ub.uu.se/rest/record/system'
#LOGIN_URL='https://alvin.pre.test.ub.uu.se/login/rest/apptoken'
#RECORDLIST_URL='https://alvin.pre.test.ub.uu.se/rest/record/indexBatchJob'

start(){
	importDeleteScript;
}

importDeleteScript() {
	SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
	source "$SCRIPT_DIR/../jobDeleteAll.sh"
}

################## calls start here #######################################
start
