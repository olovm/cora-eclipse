#! /bin/bash
NETWORK=eclipseForCoraNet

echo "starting rabbitmq"
docker run -d --name systemone-rabbitmq \
 --network=$NETWORK \
 -p 35672:5672 \
 -p 15672:15672 \
 -d --hostname systemone-rabbitmq \
 cora-docker-rabbitmq:1.0-SNAPSHOT

#echo ""
#echo "sleep 10s for rabbit to start"
#sleep 10

echo ""
echo "starting solr"
docker run -d --name systemone-solr \
 --network=$NETWORK \
 -p 38983:8983 \
 cora-solr:1.0-SNAPSHOT \
 solr-precreate coracore /opt/solr/server/solr/configsets/coradefaultcore

echo ""
#$sharedArchive is set when starting eclipse docker
echo "using host location $sharedArchive/systemOne in the eclipse docker mounted on"
echo "/tmp/sharedArchive to store the files for the archive to be able to read it from fitnesse "
echo "using path /tmp/sharedArchive/systemOne."
#docker run -d --name systemone-docker-fedora --rm \
echo "starting fedora"
docker run -d --name systemone-fedora \
 -p 38087:8080 \
 --network=$NETWORK \
 --mount type=bind,source=$sharedArchive/systemOne,target=/usr/local/tomcat/fcrepo-home/data/ocfl-root,bind-propagation=shared \
 -e CATALINA_OPTS="-Dfcrepo.config.file=/usr/local/tomcat/fcrepo.properties" \
 cora-docker-fedora:1.0-SNAPSHOT

echo "removing previous postgresql with cora data"
docker rm systemone-postgresql
echo "starting postgresql with cora data"
docker run -d --name systemone-postgresql --restart always  \
 -p 35432:5432 \
 --network=$NETWORK \
 -e POSTGRES_DB=systemone \
 -e POSTGRES_USER=systemone \
 -e POSTGRES_PASSWORD=systemone \
 systemone-docker-postgresql:1.0-SNAPSHOT

echo ""
echo "------------ STARTING BINARY CONVERTERS ------------"
echo "starting binaryConverter for imageConverterQueue"
docker run -it -d --name systemone-binarySmallImageConverter \
 --mount type=bind,source=/mnt/depot/cora/sharedArchive/systemOne,target=/tmp/sharedArchiveReadable/systemOne,readonly \
 --mount type=bind,source=/mnt/depot/cora/sharedFileStorage/systemOne,target=/tmp/sharedFileStorage/systemOne \
 --network=$NETWORK \
 -e coraBaseUrl="http://eclipse:8080/systemone/rest/" \
 -e apptokenVerifierUrl="http://eclipse:8180/apptokenverifier/rest/" \
 -e userId="141414" \
 -e appToken="63e6bd34-02a1-4c82-8001-158c104cae0e" \
 -e rabbitMqHostName="systemone-rabbitmq" \
 -e rabbitMqPort="5672" \
 -e rabbitMqVirtualHost="/" \
 -e rabbitMqQueueName="smallImageConverterQueue" \
 -e fedoraOcflHome="/tmp/sharedArchiveReadable/systemOne" \
 -e fileStorageBasePath="/tmp/sharedFileStorage/systemOne/" \
 cora-docker-binaryconverter:1.0-SNAPSHOT
 
echo ""
echo "starting binaryConverter for pdfConverterQueue"
docker run -it -d --name systemone-binaryPdfConverter \
 --mount type=bind,source=/mnt/depot/cora/sharedArchive/systemOne,target=/tmp/sharedArchiveReadable/systemOne,readonly \
 --mount type=bind,source=/mnt/depot/cora/sharedFileStorage/systemOne,target=/tmp/sharedFileStorage/systemOne \
 --network=$NETWORK \
 -e coraBaseUrl="http://eclipse:8080/systemone/rest/" \
 -e apptokenVerifierUrl="http://eclipse:8180/apptokenverifier/rest/" \
 -e userId="141414" \
 -e appToken="63e6bd34-02a1-4c82-8001-158c104cae0e" \
 -e rabbitMqHostName="systemone-rabbitmq" \
 -e rabbitMqPort="5672" \
 -e rabbitMqVirtualHost="/" \
 -e rabbitMqQueueName="pdfConverterQueue" \
 -e fedoraOcflHome="/tmp/sharedArchiveReadable/systemOne" \
 -e fileStorageBasePath="/tmp/sharedFileStorage/systemOne/" \
 cora-docker-binaryconverter:1.0-SNAPSHOT
 
echo ""
echo "starting binaryConverter for jp2ConverterQueue"
docker run -it -d --name systemone-binaryJp2Converter \
 --mount type=bind,source=/mnt/depot/cora/sharedArchive/systemOne,target=/tmp/sharedArchiveReadable/systemOne,readonly \
 --mount type=bind,source=/mnt/depot/cora/sharedFileStorage/systemOne,target=/tmp/sharedFileStorage/systemOne \
 --network=$NETWORK \
 -e coraBaseUrl="http://eclipse:8080/systemone/rest/" \
 -e apptokenVerifierUrl="http://eclipse:8180/apptokenverifier/rest/" \
 -e userId="141414" \
 -e appToken="63e6bd34-02a1-4c82-8001-158c104cae0e" \
 -e rabbitMqHostName="systemone-rabbitmq" \
 -e rabbitMqPort="5672" \
 -e rabbitMqVirtualHost="/" \
 -e rabbitMqQueueName="jp2ConverterQueue" \
 -e fedoraOcflHome="/tmp/sharedArchiveReadable/systemOne" \
 -e fileStorageBasePath="/tmp/sharedFileStorage/systemOne/" \
 cora-docker-binaryconverter:1.0-SNAPSHOT
echo "----------------------------------------------------"

echo ""
echo "starting IIPImageServer"
docker run -d --name systemone-iipimageserver \
 -p 34010:80 \
 -p 3900:9000 \
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
 cora-docker-iipimageserver:1.0-SNAPSHOT
