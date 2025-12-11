#!/bin/bash
set -uo pipefail

readRecordFromUrl(){
	local authToken="$1"
	local url="$2"
	echo $(curl -s -X GET -k -H "authToken: ${authToken}" \
    	-H "Accept: application/vnd.cora.record+xml" "$url")
}

readRecordListFromUrl(){
	local authToken="$1"
	local url="$2"
	echo $(curl -s -X GET -k -H "authToken: ${authToken}" \
    	-H "Accept: application/vnd.cora.recordList+xml" "$url")
}

sendDataToServer() {
	local authToken="$1"
	local updateLink="$2"
	local data="$3"

	local url=$(echo "$updateLink" | xmllint --xpath 'string(//url)' - 2>/dev/null)
	local method=$(echo "$updateLink" | xmllint --xpath 'string(//requestMethod)' - 2>/dev/null)
	local contentType=$(echo "$updateLink" | xmllint --xpath 'string(//contentType)' - 2>/dev/null)
	local accept=$(echo "$updateLink" | xmllint --xpath 'string(//accept)' - 2>/dev/null)

	local updateAnswer=$(curl -s -X "$method" -k \
		-H "authToken: ${authToken}" -H "Content-Type: ${contentType}" -H "Accept: ${accept}" \
		--data-binary '<?xml version="1.0" encoding="UTF-8"?>'"$data" "$url")
    echo "$updateAnswer"
}
