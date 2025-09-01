#! /bin/bash
NETWORK=eclipseForCoraNet
cora_docker_rabbitmq=cora-docker-rabbitmq:1.4-SNAPSHOT
cora_docker_solr=cora-docker-solr:1.3-SNAPSHOT
cora_docker_fedora=cora-docker-fedora:1.3-SNAPSHOT
systemone_docker_postgresql=systemone-docker-postgresql:1.13SNAPSHOT
cora_docker_iipimageserver=cora-docker-iipimageserver:1.3-SNAPSHOT
cora_docker_binaryconverter=cora-docker-binaryconverter:1.5-SNAPSHOT

start(){
	startRabbitMq
	startSolr
	startFedora
	startPostgresql
	startIIP

 	waitForServiceUsingNameAndPort systemone-rabbitmq 5672
	waitForServiceUsingNameAndPort systemone-postgresql 5432
 	
	startBinaryConverters
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
	-e DATA_DIVIDERS="cora jsClient systemOne testSystem" \
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
	 -e FILESYSTEM_PREFIX=/tmp/sharedFileStorage/systemOne/streams/ \
	 -e FILESYSTEM_SUFFIX=-jp2 \
	 -e MAX_IMAGE_CACHE_SIZE=1000 \
	 -e ALLOW_UPSCALING=0 \
	 -e OMP_NUM_THREADS=10 \
	 -e CORS=* \
	 --mount type=bind,source=/mnt/depot/cora/sharedFileStorage/systemOne,target=/tmp/sharedFileStorage/systemOne,readonly \
	 $cora_docker_iipimageserver
}

startBinaryConverters() {
	echoStartingWithMarkers "binary converters"
	startDockerForConverterUsingQueueName "smallImageConverterQueue"
	startDockerForConverterUsingQueueName "pdfConverterQueue"
	startDockerForConverterUsingQueueName "jp2ConverterQueue"
}

startDockerForConverterUsingQueueName(){
	local queueName=$1
	echo "starting binaryConverter for $queueName"
	docker run -it -d --name systemone-$queueName \
	--mount type=bind,source=/mnt/depot/cora/sharedArchive/systemOne,target=/tmp/sharedArchiveReadable/systemOne,readonly \
	--mount type=bind,source=/mnt/depot/cora/sharedFileStorage/systemOne,target=/tmp/sharedFileStorage/systemOne \
	--network=$NETWORK \
	-e coraBaseUrl="http://eclipse:8080/systemone/rest/" \
	-e apptokenVerifierUrl="http://eclipse:8180/login/rest/" \
	-e loginId="systemoneAdmin@system.cora.uu.se" \
	-e appToken="5d3f3ed4-4931-4924-9faa-8eaf5ac6457e" \
	-e rabbitMqHostName="systemone-rabbitmq" \
	-e rabbitMqPort="5672" \
	-e rabbitMqVirtualHost="/" \
	-e rabbitMqQueueName=$queueName \
	-e fedoraOcflHome="/tmp/sharedArchiveReadable/systemOne" \
	-e fileStorageBasePath="/tmp/sharedFileStorage/systemOne/" \
	$cora_docker_binaryconverter
}

waitForServiceUsingNameAndPort(){
	local name=$1
	local port=$2
	echo ""
	echo "------------ Check for service $name running on $port ------------"
	until nc -z -w1 $name $port; do
		echo "Waiting for $name..";
		sleep 1;
	done
}

start