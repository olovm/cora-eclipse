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
	SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
	source "$SCRIPT_DIR/../login.sh"
	source "$SCRIPT_DIR/../waitForSystemToBeRunning.sh"
	source "$SCRIPT_DIR/appTokenForUser.sh"
}

start "$@"