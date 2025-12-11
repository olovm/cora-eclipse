#!/bin/bash
set -uo pipefail

waitingForListOfSystemToEnsureSystemIsRunning() {
	local runningUrl=$1
 	echo "Waiting for application to start ..."
 	until curl -s --fail "${runningUrl}" > /dev/null 2>&1; do
		sleep 5
	done

	echo "Application is ready...."
}
