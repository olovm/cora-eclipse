#!/bin/bash
#set -euo pipefail
set -uo pipefail

deleteAllRecordsForUrl() {
	importDependencies
	local recordListUrl="$1"
	local deleteActionLinks=($(getDeleteActionLinks "${recordListUrl}"))
	echo "Found ${#deleteActionLinks[@]} <batch_delete> blocks"
	echo

	# Delete each entry
	for i in "${!deleteActionLinks[@]}"; do
		local deleteLink="${deleteActionLinks[$i]}"

		if [[ -n "$deleteLink" ]]; then
			deleteData "$deleteLink"
		else
			echo "⚠️  Skipping due to missing required fields"
		fi

		echo
	done
}

importDependencies(){
	SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
	source "$SCRIPT_DIR/../dataFromAndToServer.sh"
}

getDeleteActionLinks() {
 	local url="$1"
	local xml
	echo "Fetching record list XML from $url" >&2
	xml=$(readRecordListFromUrl "${AUTH_TOKEN}" "$url")

	local deleteActionLinks=()

	# Extract each <batch_delete> block
	while IFS= read -r block; do
		[[ -n "$block" ]] && deleteActionLinks+=("$block")
	done < <(echo "$xml" | \
		xmllint --xpath '//dataList/data/record/actionLinks/delete' - 2>/dev/null | \
		tr -d '\n' | sed 's|</delete>|</delete>\n|g')

	echo "${deleteActionLinks[@]}"
}

deleteData() {
	local deleteLink="$1"
	echo "DeleteLink: $deleteLink"
	local url=$(echo "$deleteLink" | xmllint --xpath 'string(//url)' - 2>/dev/null)
	local method=$(echo "$deleteLink" | xmllint --xpath 'string(//requestMethod)' - 2>/dev/null)
	
	echo
	echo "Deleteing:"
	echo "  URL: $url"
	echo "  Method: $method"
	
	local deleteAnswer=$(curl -s -X "$method" -k -H "authToken: ${AUTH_TOKEN}" "$url")
}