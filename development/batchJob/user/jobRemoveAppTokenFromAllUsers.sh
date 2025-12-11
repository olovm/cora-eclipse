#!/bin/bash
set -uo pipefail

start() {
	importDependencies
	waitingForListOfSystemToEnsureSystemIsRunning "${RUNNING_URL}"
	echo "Starting adding appToken process..."
	loginUsingIdpLogin
	removeAppTokenFromAllUsers
	logoutFromCora
}

importDependencies(){
	source "$(dirname "$0")/../login.sh"
	source "$(dirname "$0")/../waitForSystemToBeRunning.sh"
	source "$(dirname "$0")/appTokenForUser.sh"
}

removeAppTokenFromAllUsers() {
	importDependencies
#	local url="$1"
#	local note="$2"
	
	local userId="coraUser:15697099230192"
	
#	local readRecord=$(readRecordFromUrl "${AUTH_TOKEN}" "${RECORD_URL}/user/$userId")
	
	local readUsers=$(readRecordListFromUrl "${AUTH_TOKEN}" "${RECORD_URL}/user")
		echo "$readUsers">&2
	local users=()
		echo ".....1">&2

	# Extract each <batch_delete> block
	while IFS= read -r block; do
		[[ -n "$block" ]] && users+=("$block")
	done < <(echo "${readUsers}" | \
		xmllint --xpath '//dataList/data/record' - 2>/dev/null \
		| sed 's|</record>|</record>\n|g') 
#		| \
#		tr -d '\n' | sed 's|</delete>|</delete>\n|g')

		echo ".....2">&2
		echo "${users}">&2
#	echo "${users[@]}"
	for i in "${!users[@]}"; do
		local readRecord="${users[$i]}"

#		if [[ -n "$deleteLink" ]]; then
#			deleteData "$deleteLink"
#		else
#			echo "⚠️  Skipping due to missing required fields"
#		fi
		
		echo ".....2.5"
		echo "$readRecord"
		echo ".....3"
		removeAppTokensFromUserRecord "$readRecord"
	done
	
#	removeAppTokensFromUserRecord "$readRecord"
}

start "$@"