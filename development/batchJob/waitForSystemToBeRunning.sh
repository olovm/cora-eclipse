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

waitForServiceUsingNameAndPort(){
	local name=$1
	local port=$2
	echo ""
	echo "------------ Check for service $name running on $port ------------"
	until nc -z -w1 $name $port; do
		echo "Waiting for $name..";
		sleep 1;
	done
}