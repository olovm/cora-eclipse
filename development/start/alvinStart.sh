#! /bin/bash

declare dataDividers=$1
NETWORK=eclipseForCoraNet

RUNNING_URL="http://localhost:8081/alvin/rest/record/system"
RECORD_URL="http://localhost:8081/alvin/rest/record/"
RECORDTYPE_URL='http://localhost:8081/alvin/rest/record/recordType'
IDP_LOGIN_URL="http://localhost:8381/idplogin/"
LOGINID="systemoneAdmin@system.cora.uu.se"

start() {
	importDependencies
	findCurrentDockerVersions
	startRabbitMq
    startSolr
    startFedora
    startPostgresql "$dataDividers"
    startIIP

    waitForServiceUsingNameAndPort alvin-rabbitmq 5672
	waitForServiceUsingNameAndPort alvin-postgresql 5432

	echo "********************************************"
	echo "*****Start your local tomcat servers...*****"
	echo "********************************************"
	waitForServiceUsingNameAndPort localhost 8081
	waitForServiceUsingNameAndPort localhost 8181
	waitForServiceUsingNameAndPort localhost 8281
	waitForServiceUsingNameAndPort localhost 8381

    loginUsingIdpLogin
	local binaryConverterAppToken=$(addAppTokenToUser binaryConverter \
		"AppToken used by internal binary converter processes, do not remove")
	echo "Created appToken for binaryConverters: $binaryConverterAppToken"
	addAppTokenAndCreateExampleUsers "141414" "151515" "coraUser:4412566252284358"
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

	alvin_docker_postgresql="alvin-docker-postgresql:"$(getMvnVersion alvin-docker-postgresql)
	echo $alvin_docker_postgresql
	
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
    docker run -d --name alvin-rabbitmq \
        --network=$NETWORK \
        -p 15671:15672 \
        --hostname alvin-rabbitmq \
        $cora_docker_rabbitmq
}

echoStartingWithMarkers() {
    local text=$1
    echo ""
    echo "------------ STARTING ${text^^} ------------"
}

startSolr() {
    echoStartingWithMarkers "solr"
    docker run -d --name alvin-solr \
        --network=$NETWORK \
        -p 38984:8983 \
        $cora_docker_solr \
        solr-precreate coracore /opt/solr/server/solr/configsets/coradefaultcore
}

startFedora() {
	echo ""
	#$sharedArchive is set when starting eclipse docker
	echo "using host location $sharedArchive/diva in the eclipse docker mounted on"
	echo "/tmp/sharedArchive to store the files for the archive to be able to read it from fitnesse "
	echo "using path /tmp/sharedArchive/diva."
	#docker run -d --name diva-docker-fedora --rm \
	
    echoStartingWithMarkers "fedora"
    docker run -d --name alvin-fedora \
        -p 38088:8080 \
        --network=$NETWORK \
        --mount type=bind,source=$sharedArchive/alvin,target=/usr/local/tomcat/fcrepo-home/data/ocfl-root,bind-propagation=shared \
        $cora_docker_fedora
}

startPostgresql() {
    echoStartingWithMarkers "postgresql"
    echo "removing previous postgresql with cora data"
    docker rm alvin-postgresql
    echo "starting postgresql with cora data"
    docker run -d --name alvin-postgresql --restart always  \
        -p 35433:5432 \
        --network=$NETWORK \
        -e POSTGRES_DB=alvin \
        -e POSTGRES_USER=alvin \
        -e POSTGRES_PASSWORD=alvin \
        -e DATA_DIVIDERS="$1" \
        $alvin_docker_postgresql
}

startIIP() {
    echoStartingWithMarkers "IIPImageServer"
    docker run -d --name alvin-iipimageserver \
        -p 39081:80 \
        -p 39001:9000 \
        --network=$NETWORK \
        -e VERBOSITY=6 \
        -e JPEG_QUALITY=100 \
        -e PNG_QUALITY=9 \
        -e WEBP_QUALITY=100 \
        -e MAX_IMAGE_CACHE_SIZE=1000 \
        -e ALLOW_UPSCALING=0 \
        -e OMP_NUM_THREADS=10 \
        -e CORS=* \
        --mount type=bind,source=/mnt/depot/cora/sharedFileStorage/alvin,target=/tmp/sharedFileStorage/alvin,readonly \
        $cora_docker_iipimageserver
}

startBinaryConverters() {
	local binaryConverterAppToken=$1
	echoStartingWithMarkers "binary converters"
	startDockerForConverterUsingQueueName "smallImageConverterQueue" "$binaryConverterAppToken"
	startDockerForConverterUsingQueueName "pdfConverterQueue" "$binaryConverterAppToken"
	startDockerForConverterUsingQueueName "jp2ConverterQueue" "$binaryConverterAppToken"
}

startDockerForConverterUsingQueueName() {
    local queueName=$1
    local binaryConverterAppToken=$2
	echo "starting binaryConverter for $queueName"
    docker run -it -d --name alvin-$queueName \
        --mount type=bind,source=/mnt/depot/cora/sharedArchive/alvin,target=/tmp/sharedArchiveReadable/alvin,readonly \
        --mount type=bind,source=/mnt/depot/cora/sharedFileStorage/alvin,target=/tmp/sharedFileStorage/alvin \
        --network=$NETWORK \
        -e coraBaseUrl="http://eclipse:8081/alvin/rest/" \
        -e apptokenVerifierUrl="http://eclipse:8181/login/rest/" \
        -e loginId="binaryConverter@system.cora.uu.se" \
		-e appToken="$binaryConverterAppToken" \
		-e rabbitMqHostName="alvin-rabbitmq" \
        -e rabbitMqPort="5672" \
        -e rabbitMqVirtualHost="/" \
        -e rabbitMqQueueName=$queueName \
        -e fedoraOcflHome="/tmp/sharedArchiveReadable/alvin" \
        -e fileStorageBasePath="/tmp/sharedFileStorage/alvin/" \
        $cora_docker_binaryconverter
}

start