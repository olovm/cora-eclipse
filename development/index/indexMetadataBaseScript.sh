#! /bin/bash
APP_TOKEN_CONTENT_TYPE='application/vnd.uub.login'
INDEX_ACCEPT_TYPE='application/vnd.uub.record+json'

login(){
	local loginAnswer=$(curl -s -X POST -H "Content-Type: "$APP_TOKEN_CONTENT_TYPE -k -i ${LOGIN_URL} --data-binary ${LOGIN_ID}$'\n'${APP_TOKEN});
	echo 'LoginAnswer: '${loginAnswer} 
	AUTH_TOKEN=$(echo ${loginAnswer} | grep -o -P '(?<={"name":"token","value":").*?(?="})')
	LOGOUT_URL=$(echo ${loginAnswer} | grep -o -P '(?<="rel":"delete","url":").*?(?=")')
	echo 'Logged in...'
	echo 'Parsed authToken: '${AUTH_TOKEN} 
	echo 'Parsed logout URL: '${LOGOUT_URL} 
}

indexMetadata(){
	echo ""
	local recordType=$1
	echo 'Indexing recordType: '${recordType}
	local indexAnswer=$(curl -s -X POST -k -H 'authToken: '${AUTH_TOKEN} -i ${INDEX_URL}'/'${recordType} -H 'Accept: '${INDEX_ACCEPT_TYPE})
	echo 'IndexAnswer: '${indexAnswer}
	
	local indexAnswerId=$(echo ${indexAnswer} | grep -o -P '(?<={"name":"id","value":").*?(?="})')
	echo 'IndexAnswerId: '${indexAnswerId}
}

logoutFromCora(){
	echo ""
	echo 'Logg out using' ${LOGOUT_URL} 
	curl -s -X DELETE -k -H 'authToken: '${AUTH_TOKEN} -i ${LOGOUT_URL}
	echo 'Logged out' 
}