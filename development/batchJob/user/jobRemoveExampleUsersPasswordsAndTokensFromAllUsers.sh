#!/bin/bash
set -uo pipefail

start() {
	importDependencies
	waitingForListOfSystemToEnsureSystemIsRunning "${RUNNING_URL}"
	echo "Starting adding appToken process..."
	loginUsingIdpLogin
	deleteAllRecordsForUrl "${RECORD_URL}exampleUser"
	removeAppTokenAndPasswordFromAllUsers
	logoutFromCora
}

importDependencies(){
	SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
	source "$SCRIPT_DIR/../login.sh"
	source "$SCRIPT_DIR/../waitForSystemToBeRunning.sh"
	source "$SCRIPT_DIR/../deleteAllRecordsForUrl.sh"
	source "$SCRIPT_DIR/appTokenForUser.sh"
}

removeAppTokenAndPasswordFromAllUsers() {
	importDependencies
	local readUsers=$(readRecordListFromUrl "${AUTH_TOKEN}" "${RECORD_URL}user")
	local users=()
	while IFS= read -r block; do
		[[ -n "$block" ]] && users+=("$block")
	done < <(echo "${readUsers}" | \
		xmllint --xpath '//dataList/data/record' - 2>/dev/null \
		| sed 's|</record>|</record>\n|g') 

	for i in "${!users[@]}"; do
		local readRecord="${users[$i]}"
		local updateAnswer=$(removeAppTokensAndPasswordFromUserRecord "$readRecord")
		if [[ "$updateAnswer" != "" ]]; then
			local id=$(getIdFromAnswer "$updateAnswer")
			echo "Removing password and/or token from user: ${id}"
		fi
	done
}

getIdFromAnswer(){
	local answer="$1"
	echo $(echo "$answer" | xmllint --xpath 'string(//record/data/user/recordInfo/id)' - 2>/dev/null)
}


start "$@"