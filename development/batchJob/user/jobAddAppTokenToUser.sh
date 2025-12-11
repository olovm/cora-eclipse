#!/bin/bash
set -uo pipefail

start() {
	local userId=$1
	local note=$2
	importDependencies
	waitingForListOfSystemToEnsureSystemIsRunning "${RUNNING_URL}"
	echo "Starting adding appToken process..."
	loginUsingIdpLogin
	addAppTokenToUser $userId "$note"
	logoutFromCora
}

importDependencies(){
	source "$(dirname "$0")/../login.sh"
	source "$(dirname "$0")/../waitForSystemToBeRunning.sh"
	source "$(dirname "$0")/appTokenForUser.sh"
}

start "$@"