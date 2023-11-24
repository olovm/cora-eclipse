#! /bin/bash

echo "starting rabbitmq"
docker run -d --name systemone-rabbitmq \
--network=eclipseForCoraNet \
-p 35672:5672 \
-p 15672:15672 \
-d --hostname systemone-rabbitmq \
cora-docker-rabbitmq:1.0-SNAPSHOT

echo "sleep 5s for rabbit to start"
sleep 5

echo "starting binaryConverter for smallConverterQueue"
docker run -it -d --name systemone-binaryConverterSmall \
--mount type=bind,source=/mnt/depot/cora/sharedArchive/systemOne,target=/tmp/sharedArchiveReadable/systemOne,readonly \
--mount type=bind,source=/mnt/depot/cora/sharedFileStorage/systemOne,target=/tmp/sharedFileStorage/systemOne \
--network=eclipseForCoraNet \
-e coraBaseUrl="http://eclipse:8080/systemone/rest/" \
-e apptokenVerifierUrl="http://eclipse:8180/apptokenverifier/rest/" \
-e userId="141414" \
-e appToken="63e6bd34-02a1-4c82-8001-158c104cae0e" \
-e rabbitMqHostName="systemone-rabbitmq" \
-e rabbitMqPort="5672" \
-e rabbitMqVirtualHost="/" \
-e rabbitMqQueueName="smallConverterQueue" \
-e fedoraOcflHome="/tmp/sharedArchiveReadable/systemOne" \
-e fileStorageBasePath="/tmp/sharedFileStorage/systemOne/" \
cora-docker-binaryconverter:1.0-SNAPSHOT

echo "starting solr"
docker run -d --name systemone-solr \
--network=eclipseForCoraNet \
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
--network=eclipseForCoraNet \
--mount type=bind,source=$sharedArchive/systemOne,target=/usr/local/tomcat/fcrepo-home/data/ocfl-root,bind-propagation=shared \
-e CATALINA_OPTS="-Dfcrepo.config.file=/usr/local/tomcat/fcrepo.properties" \
cora-docker-fedora:1.0-SNAPSHOT

echo "removing previous postgresql with cora data"
docker rm systemone-postgresql
echo "starting postgresql with cora data"
docker run -d --name systemone-postgresql --restart always  \
-p 35432:5432 \
--network=eclipseForCoraNet \
-e POSTGRES_DB=systemone \
-e POSTGRES_USER=systemone \
-e POSTGRES_PASSWORD=systemone \
systemone-docker-postgresql:1.0-SNAPSHOT

#--mount type=bind,source=/mnt/depot/cora/sharedArchive,target=/usr/local/tomcat/fcrepo-home/data/ocfl-root,bind-propagation=shared \

#--volumes-from eclipse202309forcora2 \
