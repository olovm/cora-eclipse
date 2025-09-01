#! /bin/bash

NETWORK=eclipseForCoraNet
cora_docker_rabbitmq=cora-docker-rabbitmq:1.4-SNAPSHOT
cora_docker_solr=cora-docker-solr:1.3-SNAPSHOT
cora_docker_fedora=cora-docker-fedora:1.3-SNAPSHOT
diva_docker_postgresql=diva-docker-postgresql:1.29-SNAPSHOT
cora_docker_iipimageserver=cora-docker-iipimageserver:1.3-SNAPSHOT
cora_docker_binaryconverter=cora-docker-binaryconverter:1.5-SNAPSHOT

start() {
    startRabbitMq
    startSolr
    startFedora
    startPostgresql
    startIIP

    waitForServiceUsingNameAndPort diva-rabbitmq 5672
	waitForServiceUsingNameAndPort diva-postgresql 5432

    startBinaryConverters
}

startRabbitMq() {
    echoStartingWithMarkers "rabbitmq"
    docker run -d --name diva-rabbitmq \
        --network=$NETWORK \
        -p 15672:15672 \
        --hostname diva-rabbitmq \
        $cora_docker_rabbitmq
}

echoStartingWithMarkers() {
    local text=$1
    echo ""
    echo "------------ STARTING ${text^^} ------------"
}

startSolr() {
    echoStartingWithMarkers "solr"
    docker run -d --name diva-solr \
        --network=$NETWORK \
        -p 38985:8983 \
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
    docker run -d --name diva-fedora \
        -p 38089:8080 \
        --network=$NETWORK \
        --mount type=bind,source=$sharedArchive/diva,target=/usr/local/tomcat/fcrepo-home/data/ocfl-root,bind-propagation=shared \
        $cora_docker_fedora
}

startPostgresql() {
    echoStartingWithMarkers "postgresql"
    echo "removing previous postgresql with cora data"
    docker rm diva-postgresql
    echo "starting postgresql with cora data"
    docker run -d --name diva-postgresql --restart always  \
        -p 35434:5432 \
        --network=$NETWORK \
        -e POSTGRES_DB=diva \
        -e POSTGRES_USER=diva \
        -e POSTGRES_PASSWORD=diva \
        -e DATA_DIVIDERS="cora jsClient diva divaPreview divaPre divaProduction divaClient" \
        $diva_docker_postgresql
}

startIIP() {
    echoStartingWithMarkers "IIPImageServer"
    docker run -d --name diva-iipimageserver \
        -p 39082:80 \
        -p 39002:9000 \
        --network=$NETWORK \
        -e VERBOSITY=6 \
        -e JPEG_QUALITY=100 \
        -e PNG_QUALITY=9 \
        -e WEBP_QUALITY=100 \
        -e FILESYSTEM_PREFIX=/tmp/sharedFileStorage/diva/streams/ \
        -e FILESYSTEM_SUFFIX=-jp2 \
        -e MAX_IMAGE_CACHE_SIZE=1000 \
        -e ALLOW_UPSCALING=0 \
        -e OMP_NUM_THREADS=10 \
        -e CORS=* \
        --mount type=bind,source=/mnt/depot/cora/sharedFileStorage/diva,target=/tmp/sharedFileStorage/diva,readonly \
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
    docker run -it -d --name diva-$queueName \
        --mount type=bind,source=/mnt/depot/cora/sharedArchive/diva,target=/tmp/sharedArchiveReadable/diva,readonly \
        --mount type=bind,source=/mnt/depot/cora/sharedFileStorage/diva,target=/tmp/sharedFileStorage/diva \
        --network=$NETWORK \
        -e coraBaseUrl="http://eclipse:8082/diva/rest/" \
        -e apptokenVerifierUrl="http://eclipse:8182/login/rest/" \
        -e loginId="systemoneAdmin@system.cora.uu.se" \
        -e appToken="5d3f3ed4-4931-4924-9faa-8eaf5ac6457e" \
        -e rabbitMqHostName="diva-rabbitmq" \
        -e rabbitMqPort="5672" \
        -e rabbitMqVirtualHost="/" \
        -e rabbitMqQueueName=$queueName \
        -e fedoraOcflHome="/tmp/sharedArchiveReadable/diva" \
        -e fileStorageBasePath="/tmp/sharedFileStorage/diva/" \
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