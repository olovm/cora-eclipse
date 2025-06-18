#! /bin/bash

NETWORK=eclipseForCoraNet
cora_docker_rabbitmq=cora-docker-rabbitmq:1.3-SNAPSHOT
cora_docker_solr=cora-docker-solr:1.2-SNAPSHOT
cora_docker_fedora=cora-docker-fedora:1.0-SNAPSHOT
alvin_docker_postgresql=alvin-docker-postgresql:1.6-SNAPSHOT
cora_docker_iipimageserver=cora-docker-iipimageserver:1.0-SNAPSHOT
cora_docker_binaryconverter=cora-docker-binaryconverter:1.0-SNAPSHOT

start() {
    startRabbitMq
    startSolr
    startFedora
    startPostgresql
    startIIP

    waitForServiceUsingNameAndPort alvin-rabbitmq 5672
	waitForServiceUsingNameAndPort alvin-postgresql 5432

    startBinaryConverters
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
        -e DATA_DIVIDERS="cora jsClient alvin alvinPreview alvinTestSystem alvinProduction alvinData" \
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
        -e FILESYSTEM_PREFIX=/tmp/sharedFileStorage/alvin/streams/ \
        -e FILESYSTEM_SUFFIX=-jp2 \
        -e MAX_IMAGE_CACHE_SIZE=1000 \
        -e ALLOW_UPSCALING=0 \
        -e OMP_NUM_THREADS=10 \
        -e CORS=* \
        --mount type=bind,source=/mnt/depot/cora/sharedFileStorage/alvin,target=/tmp/sharedFileStorage/alvin,readonly \
        $cora_docker_iipimageserver
}

startBinaryConverters() {
    echoStartingWithMarkers "binary converters"
    startDockerForConverterUsingQueueName "smallImageConverterQueue"
    startDockerForConverterUsingQueueName "pdfConverterQueue"
    startDockerForConverterUsingQueueName "jp2ConverterQueue"
}

startDockerForConverterUsingQueueName() {
    local queueName=$1
    echo "starting binaryConverter for $queueName"
    docker run -it -d --name alvin-$queueName \
        --mount type=bind,source=/mnt/depot/cora/sharedArchive/alvin,target=/tmp/sharedArchiveReadable/alvin,readonly \
        --mount type=bind,source=/mnt/depot/cora/sharedFileStorage/alvin,target=/tmp/sharedFileStorage/alvin \
        --network=$NETWORK \
        -e coraBaseUrl="http://eclipse:8081/alvin/rest/" \
        -e apptokenVerifierUrl="http://eclipse:8181/login/rest/" \
        -e loginId="systemoneAdmin@system.cora.uu.se" \
        -e appToken="5d3f3ed4-4931-4924-9faa-8eaf5ac6457e" \
        -e rabbitMqHostName="alvin-rabbitmq" \
        -e rabbitMqPort="5672" \
        -e rabbitMqVirtualHost="/" \
        -e rabbitMqQueueName=$queueName \
        -e fedoraOcflHome="/tmp/sharedArchiveReadable/alvin" \
        -e fileStorageBasePath="/tmp/sharedFileStorage/alvin/" \
        $cora_docker_binaryconverter
}

waitForServiceUsingNameAndPort(){
	local name=$1
	local port=$2
	echo ""
	echo "------------ Check for service $name running on $port ------------"
	until nc -z -v -w1 $name $port >/dev/null 2>&1; do
		echo "Waiting for $name..";
		sleep 1;
	done
}

start