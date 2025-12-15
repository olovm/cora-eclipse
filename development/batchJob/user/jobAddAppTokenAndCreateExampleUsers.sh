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
	SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
	source "$SCRIPT_DIR/../login.sh"
	source "$SCRIPT_DIR/../waitForSystemToBeRunning.sh"
	source "$SCRIPT_DIR/appTokenForUser.sh"
}

start "$@"