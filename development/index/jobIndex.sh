#!/bin/bash
#set -euo pipefail
set -uo pipefail

start() {
  waitingForListOfSystemToEnsureSystemIsRunning
  echo "Starting indexing process..."
  login
  index
  logoutFromCora
}

waitingForListOfSystemToEnsureSystemIsRunning(){
  echo "Waiting for application to start ..."
  until curl -s --fail "${RECORDTYPE_URL}" > /dev/null 2>&1; do
    sleep 5
  done

  echo "Application is ready. Running indexing script..."
}

login() {
  echo "Logging in.."
  local loginAnswer
  loginAnswer=$(curl -s -X POST -H "Content-Type: application/vnd.cora.login" -k -i "${LOGIN_URL}" --data "${LOGINID}"$'\n'"${APP_TOKEN}")

  AUTH_TOKEN=$(echo "${loginAnswer}" | grep -oP '(?<={"name":"token","value":")[^"]+')
  AUTH_TOKEN_DELETE_URL=$(echo "${loginAnswer}" | grep -oP '(?<="url":")[^"]+')
  echo "Logged in... "
}

index() {
  # Get index action links
  local indexActionLinks=($(getIndexActionLinks "${RECORDTYPE_URL}"))

  echo "Found ${#indexActionLinks[@]} <batch_index> blocks"
  echo

  # Index each entry
  for i in "${!indexActionLinks[@]}"; do
    local indexLink="${indexActionLinks[$i]}"

    if [[ -n "$indexLink" ]]; then
      indexData "$indexLink"
    else
      echo "⚠️  Skipping due to missing required fields"
    fi

    echo
  done
}

getIndexActionLinks() {
  local url="$1"
  local xml
  echo "Fetching record list XML from $url" >&2
  xml=$(curl -s -X GET -k -H "authToken: ${AUTH_TOKEN}" \
    -H "Accept: application/vnd.cora.recordList+xml" "$url")

  local indexActionLinks=()

  # Extract each <batch_index> block
  while IFS= read -r block; do
    [[ -n "$block" ]] && indexActionLinks+=("$block")
  done < <(echo "$xml" | \
    xmllint --xpath '//dataList/data/record/actionLinks/batch_index' - 2>/dev/null | \
    tr -d '\n' | sed 's|</batch_index>|</batch_index>\n|g')

  echo "${indexActionLinks[@]}"
}

indexData() {
  local indexLink="$1"
  echo "IndexLink: $indexLink"
  local url=$(echo "$indexLink" | xmllint --xpath 'string(//url)' - 2>/dev/null)
  local method=$(echo "$indexLink" | xmllint --xpath 'string(//requestMethod)' - 2>/dev/null)
  local contentType=$(echo "$indexLink" | xmllint --xpath 'string(//contentType)' - 2>/dev/null)
  local accept=$(echo "$indexLink" | xmllint --xpath 'string(//accept)' - 2>/dev/null)

  echo
  echo "Indexing:"
  echo "  URL: $url"
  echo "  Method: $method"
  echo "  Content-Type: $contentType"
  echo "  Accept: $accept"

  if [[ -n "$url" && -n "$method" ]]; then
    local indexAnswer=$(curl -s -X "$method" -k -H "authToken: ${AUTH_TOKEN}" -H "Content-Type: ${contentType}" -H "Accept: ${accept}" "$url")
    local indexAnswerId=$(echo "$indexAnswer" | xmllint --xpath 'string(/record/data/indexBatchJob/recordInfo/id)' - 2>/dev/null)
    echo "IndexAnswerId: ${indexAnswerId}"
  else
    echo "⚠️  Skipping due to missing required fields"
  fi
}

logoutFromCora() {
  echo
  echo "Logging out from ${AUTH_TOKEN_DELETE_URL}"
  curl -s -X DELETE -k -H "authToken: ${AUTH_TOKEN}" -i "${AUTH_TOKEN_DELETE_URL}"
  echo "Logged out"
}

start