#!/bin/bash
set -uo pipefail

start() {
  importLogin
  waitingForListOfSystemToEnsureSystemIsRunning
  echo "Starting indexing process..."
#  loginUsingAppToken
  loginUsingIdpLogin
  index
  logoutFromCora
}

importLogin(){
	source "$(dirname "$0")/login.sh"
}

waitingForListOfSystemToEnsureSystemIsRunning(){
  echo "Waiting for application to start ..."
  until curl -s --fail "${RUNNING_URL}" > /dev/null 2>&1; do
    sleep 5
  done

  echo "Application is ready. Running indexing script..."
}

index() {
  # Get index action links
#  local indexActionLinks=($(getIndexActionLinks "${RECORDTYPE_URL}"))
  local indexActionLinks=($(getIndexActionLinks "${USER_URL}/141414"))

#  echo "Found ${#indexActionLinks[@]} <batch_index> blocks"
#  echo
#
#  # Index each entry
#  for i in "${!indexActionLinks[@]}"; do
#    local indexLink="${indexActionLinks[$i]}"
#
#    if [[ -n "$indexLink" ]]; then
#      indexData "$indexLink"
#    else
#      echo "⚠️  Skipping due to missing required fields"
#    fi
#
#    echo
#  done
}

getIndexActionLinks() {
  local url="$1"
  local xml
  echo "Fetching record XML from $url" >&2
  xml=$(curl -s -X GET -k -H "authToken: ${AUTH_TOKEN}" \
    -H "Accept: application/vnd.cora.record+xml" "$url")
  echo "$xml" >&2
  
  echo ".....1" >&2
  local updateLink=$(echo "$xml" | xmllint --xpath '//record/actionLinks/update' - 2>/dev/null)
  echo "$updateLink" >&2

  echo ".....2" >&2
  local user=$(echo "$xml" | xmllint --xpath '//record/data/user' - 2>/dev/null)
  echo "$user" >&2
  
  echo ".....3" >&2
  local userNoActionLinks=$(printf '%s\n' "$user" \
    | xmlstarlet ed --omit-decl -d "//actionLinks" 2>/dev/null)
  echo "$userNoActionLinks" >&2
  echo ".....4" >&2
  
  
  # Add <appTokens> if missing, then add <appToken> inside it
  # Create <appTokens> if it does not exist
  # Add <appToken> as last child of <appTokens>
updated_xml=$(xmlstarlet ed --omit-decl \
  -i "/user[not(appTokens)]" -t elem -n appTokens -v "" \
  -s "/user/appTokens" -t elem -n appToken -v "" \
  -i "/user/appTokens/appToken[last()]" -t attr -n repeatId -v "99999" \
  -s "/user/appTokens/appToken[last()]" -t elem -n appTokenNote -v "Token for XYZ" \
  <<< "$userNoActionLinks")
  # Add <appTokenNote> inside the new <appToken>
#  -s "/user/appTokens/appToken[last()]" -t elem -n appTokenNote -v "Token for XYZ" \

echo "$updated_xml" >&2
  echo ".....5" >&2
  
#   <appToken repeatId="0"><appTokenNote>Token for development</appTokenNote></appToken>
#  appTokenClearText

  updateData "${updateLink}" "${updated_xml}"
  echo ".....6" >&2
  
#  local indexActionLinks=()
	
  # Extract each <batch_index> block
#  while IFS= read -r block; do
#    [[ -n "$block" ]] && indexActionLinks+=("$block")
#  done < <(echo "$xml" | \
#    xmllint --xpath '//dataList/data/record/actionLinks/batch_index' - 2>/dev/null | \
#    tr -d '\n' | sed 's|</batch_index>|</batch_index>\n|g')
#
#  echo "${indexActionLinks[@]}"
}

updateData() {
  echo "update.....1" >&2
  local updateLink="$1"
  local data="$2"
  
  echo "update.....2" >&2
  echo "updateLink: $updateLink" >&2
  local url=$(echo "$updateLink" | xmllint --xpath 'string(//url)' - 2>/dev/null)
  local method=$(echo "$updateLink" | xmllint --xpath 'string(//requestMethod)' - 2>/dev/null)
  local contentType=$(echo "$updateLink" | xmllint --xpath 'string(//contentType)' - 2>/dev/null)
  local accept=$(echo "$updateLink" | xmllint --xpath 'string(//accept)' - 2>/dev/null)

  echo "update.....3" >&2
  echo
  echo "Updating:">&2
  echo "  URL: $url">&2
  echo "  Method: $method">&2
  echo "  Content-Type: $contentType">&2
  echo "  Accept: $accept">&2
  echo "update.....4" >&2
  echo "  data: $data">&2

  if [[ -n "$url" && -n "$method" ]]; then
    local updateAnswer=$(curl -s -X "$method" -k \
      -H "authToken: ${AUTH_TOKEN}" -H "Content-Type: ${contentType}" -H "Accept: ${accept}" \
      --data-binary '<?xml version="1.0" encoding="UTF-8"?>'"$data" "$url")
    echo "updateAnswer: ${updateAnswer}">&2
      
    local token=$(echo "$updateAnswer" | \
      xmllint --xpath 'string(/record/data/user/appTokens/appToken[last()]/appTokenClearText)' - 2>/dev/null)
    echo "token: ${token}">&2
  else
    echo "⚠️  Skipping due to missing required fields">&2
  fi
}


start