#!/bin/bash
#set -euo pipefail
set -uo pipefail

start() {
 	importDependencies
	waitingForListOfSystemToEnsureSystemIsRunning "${RUNNING_URL}"
	echo "Starting delete all process..."
	loginUsingIdpLogin
	deleteAllRecordsForUrl "${RECORDLIST_URL}"
	logoutFromCora
}

importDependencies(){
	SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
	source "$SCRIPT_DIR/login.sh"
	source "$SCRIPT_DIR//waitForSystemToBeRunning.sh"
	source "$SCRIPT_DIR//deleteAllRecordsForUrl.sh"
}

start