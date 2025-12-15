#! /bin/bash

declare dataDividers=$1
NETWORK=eclipseForCoraNet

RUNNING_URL="http://localhost:8080/systemone/rest/record/system"
RECORD_URL="http://localhost:8080/systemone/rest/record/"
RECORDTYPE_URL='http://localhost:8080/systemone/rest/record/recordType'
IDP_LOGIN_URL="http://localhost:8380/idplogin/"
LOGINID="systemoneAdmin@system.cora.uu.se"

start(){
	importDependencies
	findCurrentDockerVersions
	startRabbitMq
	startSolr
	startFedora
    startPostgresql "$dataDividers"
    startIIP

 	waitForServiceUsingNameAndPort systemone-rabbitmq 5672
	waitForServiceUsingNameAndPort systemone-postgresql 5432
	
	echo "********************************************"
	echo "*****Start your local tomcat servers...*****"
	echo "********************************************"
	waitForServiceUsingNameAndPort localhost 8080
	waitForServiceUsingNameAndPort localhost 8180
	waitForServiceUsingNameAndPort localhost 8280
	waitForServiceUsingNameAndPort localhost 8380
 	 	
 	loginUsingIdpLogin
	local binaryConverterAppToken=$(addAppTokenToUser binaryConverter \
		"AppToken used by internal binary converter processes, do not remove")
	echo "Created appToken for binaryConverters: $binaryConverterAppToken"
	addAppTokenAndCreateExampleUsers "141414"
 	index
	logoutFromCora
	
	startBinaryConverters "$binaryConverterAppToken"
}

importDependencies(){
	SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
	source "$SCRIPT_DIR/../batchJob/waitForSystemToBeRunning.sh"
	source "$SCRIPT_DIR/../batchJob/login.sh"
	source "$SCRIPT_DIR/../batchJob/user/appTokenForUser.sh"
	source "$SCRIPT_DIR/../batchJob/index/index.sh"
}

findCurrentDockerVersions() {
	echo "Finding current local docker versions...."

	cora_docker_rabbitmq="cora-docker-rabbitmq:"$(getMvnVersion cora-docker-rabbitmq)
	echo $cora_docker_rabbitmq

	cora_docker_solr="cora-docker-solr:"$(getMvnVersion cora-docker-solr)
	echo $cora_docker_solr

	cora_docker_fedora="cora-docker-fedora:"$(getMvnVersion cora-docker-fedora)
	echo $cora_docker_fedora

	systemone_docker_postgresql="systemone-docker-postgresql:"$(getMvnVersion systemone-docker-postgresql)
	echo $systemone_docker_postgresql
	
	cora_docker_iipimageserver="cora-docker-iipimageserver:"$(getMvnVersion cora-docker-iipimageserver)
	echo $cora_docker_iipimageserver
	
	cora_docker_binaryconverter="cora-docker-binaryconverter:"$(getMvnVersion /cora-docker-binaryconverter)
	echo $cora_docker_binaryconverter
}

getMvnVersion() {
    mvn -f "$HOME/workspace/$1/pom.xml" help:evaluate -Dexpression=project.version -q -DforceStdout
}

startRabbitMq() {
	echoStartingWithMarkers "rabbitmq"
	docker run -d --name systemone-rabbitmq \
	--network=$NETWORK \
	-p 15670:15672 \
	--hostname systemone-rabbitmq \
	$cora_docker_rabbitmq
}

echoStartingWithMarkers() {
	local text=$1
	echo ""
	echo "------------ STARTING ${text^^} ------------"
}

startSolr(){
	echoStartingWithMarkers "solr"
	docker run -d --name systemone-solr \
	--network=$NETWORK \
	-p 38983:8983 \
	$cora_docker_solr \
	solr-precreate coracore /opt/solr/server/solr/configsets/coradefaultcore
}

startFedora() {
	echoStartingWithMarkers "fedora"
	#$sharedArchive is set when starting eclipse docker
	echo "using host location $sharedArchive/systemOne in the eclipse docker mounted on"
	echo "/tmp/sharedArchive to store the files for the archive to be able to read it from fitnesse "
	echo "using path /tmp/sharedArchive/systemOne."
	docker run -d --name systemone-fedora \
	-p 38087:8080 \
	--network=$NETWORK \
	--mount type=bind,source=$sharedArchive/systemOne,target=/usr/local/tomcat/fcrepo-home/data/ocfl-root,bind-propagation=shared \
	-e CATALINA_OPTS="-Dfcrepo.config.file=/usr/local/tomcat/fcrepo.properties" \
	$cora_docker_fedora
}

startPostgresql(){
	echoStartingWithMarkers "postgresql"
	echo "removing previous postgresql with cora data"
	docker rm systemone-postgresql
	echo "starting postgresql with cora data"
	docker run -d --name systemone-postgresql --restart always  \
	-p 35432:5432 \
	--network=$NETWORK \
	-e POSTGRES_DB=systemone \
	-e POSTGRES_USER=systemone \
	-e POSTGRES_PASSWORD=systemone \
	-e DATA_DIVIDERS="$1" \
	$systemone_docker_postgresql
}
#--mount type=bind,source=/mnt/depot/cora/sharedArchive,target=/usr/local/tomcat/fcrepo-home/data/ocfl-root,bind-propagation=shared \

startIIP() {
	echoStartingWithMarkers "IIPImageServer"
	docker run -d --name systemone-iipimageserver \
	 --network-alias=iiifserver \
	 -p 39080:80 \
	 -p 39000:9000 \
	 --network=$NETWORK \
	 -e VERBOSITY=6 \
	 -e JPEG_QUALITY=100 \
	 -e PNG_QUALITY=9 \
	 -e WEBP_QUALITY=100 \
	 -e MAX_IMAGE_CACHE_SIZE=1000 \
	 -e ALLOW_UPSCALING=0 \
	 -e OMP_NUM_THREADS=10 \
	 -e CORS=* \
	 --mount type=bind,source=/mnt/depot/cora/sharedFileStorage/systemOne,target=/tmp/sharedFileStorage/systemOne,readonly \
	 $cora_docker_iipimageserver
}

startBinaryConverters() {
	local binaryConverterAppToken=$1
	echoStartingWithMarkers "binary converters"
	startDockerForConverterUsingQueueName "smallImageConverterQueue" "$binaryConverterAppToken"
	startDockerForConverterUsingQueueName "pdfConverterQueue" "$binaryConverterAppToken"
	startDockerForConverterUsingQueueName "jp2ConverterQueue" "$binaryConverterAppToken"
}

startDockerForConverterUsingQueueName(){
	local queueName=$1
	local binaryConverterAppToken=$2
	echo "starting binaryConverter for $queueName"
	docker run -it -d --name systemone-$queueName \
	--mount type=bind,source=/mnt/depot/cora/sharedArchive/systemOne,target=/tmp/sharedArchiveReadable/systemOne,readonly \
	--mount type=bind,source=/mnt/depot/cora/sharedFileStorage/systemOne,target=/tmp/sharedFileStorage/systemOne \
	--network=$NETWORK \
	-e coraBaseUrl="http://eclipse:8080/systemone/rest/" \
	-e apptokenVerifierUrl="http://eclipse:8180/login/rest/" \
	-e loginId="binaryConverter@system.cora.uu.se" \
	-e appToken="$binaryConverterAppToken" \
	-e rabbitMqHostName="systemone-rabbitmq" \
	-e rabbitMqPort="5672" \
	-e rabbitMqVirtualHost="/" \
	-e rabbitMqQueueName=$queueName \
	-e fedoraOcflHome="/tmp/sharedArchiveReadable/systemOne" \
	-e fileStorageBasePath="/tmp/sharedFileStorage/systemOne/" \
	$cora_docker_binaryconverter
}

start