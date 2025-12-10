#!/bin/bash
#set -euo pipefail
set -uo pipefail

start() {
 	importLogin
	waitingForListOfSystemToEnsureSystemIsRunning
	echo "Starting delete all batch jobs process..."
	loginUsingIdpLogin
	delete
	logoutFromCora
}

importLogin(){
	source "$(dirname "$0")/login.sh"
}

waitingForListOfSystemToEnsureSystemIsRunning(){
  echo "Waiting for application to start ..."
  until curl -s --fail "${RUNNING_URL}" > /dev/null 2>&1; do
    sleep 5
    echo "Waiting for application to start ..."
  done

  echo "Application is ready. Running delete script..."
}

delete() {
  # Get delete action links
  local deleteActionLinks=($(getDeleteActionLinks "${RECORDLIST_URL}"))

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

getDeleteActionLinks() {
  local url="$1"
  local xml
  echo "Fetching record list XML from $url" >&2
  xml=$(curl -s -X GET -k -H "authToken: ${AUTH_TOKEN}" \
    -H "Accept: application/vnd.cora.recordList+xml" "$url")

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
  local contentType=$(echo "$deleteLink" | xmllint --xpath 'string(//contentType)' - 2>/dev/null)
  local accept=$(echo "$deleteLink" | xmllint --xpath 'string(//accept)' - 2>/dev/null)

  echo
  echo "Deleteing:"
  echo "  URL: $url"
  echo "  Method: $method"
  echo "  Content-Type: $contentType"
  echo "  Accept: $accept"

  if [[ -n "$url" && -n "$method" ]]; then
    local deleteAnswer=$(curl -s -X "$method" -k -H "authToken: ${AUTH_TOKEN}" -H "Content-Type: ${contentType}" -H "Accept: ${accept}" "$url")
    local deleteAnswerId=$(echo "$deleteAnswer" | xmllint --xpath 'string(/record/data/deleteBatchJob/recordInfo/id)' - 2>/dev/null)
    echo "DeleteAnswerId: ${deleteAnswerId}"
  else
    echo "⚠️  Skipping due to missing required fields"
  fi
}

start