#!/bin/bash
#set -euo pipefail
set -uo pipefail

start() {
 	importDependencies
	waitingForListOfSystemToEnsureSystemIsRunning "${RUNNING_URL}"
	echo "Starting delete all batch jobs process..."
	loginUsingIdpLogin
	deleteAllRecordsForUrl "${RECORDLIST_URL}"
	logoutFromCora
}

importDependencies(){
	source "$(dirname "$0")/../login.sh"
	source "$(dirname "$0")/../waitForSystemToBeRunning.sh"
	source "$(dirname "$0")/../deleteAllRecordsForUrl.sh"
}

start