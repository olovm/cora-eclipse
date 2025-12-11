#!/bin/bash
set -uo pipefail

start() {
	local userIds="$@"
	importDependencies
	waitingForListOfSystemToEnsureSystemIsRunning "${RUNNING_URL}"
	echo "Starting adding appTokens process..."
	loginUsingIdpLogin
	addAppTokenAndCreateExampleUsers $userIds
	logoutFromCora
}

importDependencies(){
	source "$(dirname "$0")/../login.sh"
	source "$(dirname "$0")/../waitForSystemToBeRunning.sh"
	source "$(dirname "$0")/appTokenForUser.sh"
}

start "$@"