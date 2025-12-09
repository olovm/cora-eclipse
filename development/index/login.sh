#!/bin/bash
set -uo pipefail

loginUsingAppToken() {
  echo "Logging in.."
  local loginAnswer
  loginAnswer=$(curl -s -X POST \
  -H "Content-Type: application/vnd.cora.login" \
  -k -i "${LOGIN_URL}" \
  --data "${LOGINID}"$'\n'"${APP_TOKEN}")
  setTokens "$loginAnswer"
  echo "Logged in... "
}

loginUsingIdpLogin() {
  echo "Logging in.. ${LOGINID}"
  local loginAnswer
  loginAnswer=$(curl -s -X GET \
  -H "accept: application/vnd.cora.authentication+json" \
  -H "eppn: ${LOGINID}" \
  -k -i "${IDP_LOGIN_URL}login")
  setTokens "$loginAnswer"
  echo "Logged in... "
}
  
setTokens() {
  local loginAnswer="$1"
#  echo "loginAnser in setTokens: ${loginAnswer}"
  AUTH_TOKEN=$(echo "${loginAnswer}" | grep -oP '(?<={"name":"token","value":")[^"]+')
  AUTH_TOKEN_DELETE_URL=$(echo "${loginAnswer}" | grep -oP '(?<="url":")[^"]+')
}

logoutFromCora() {
  echo
  echo "Logging out from ${AUTH_TOKEN_DELETE_URL}"
  curl -s -X DELETE -k -H "authToken: ${AUTH_TOKEN}" -i "${AUTH_TOKEN_DELETE_URL}"
  echo "Logged out"
}