#! /bin/bash

echo "starting diva synchronizer"
docker run -d --name diva-docker-synchronizer --rm \
-p 38482:8080 \
--network=eclipseForCoraNet \
--network-alias=synchronizer \
-e "JAVA_OPTS=\
-DapptokenVerifierURL=http://eclipse:8182/apptokenverifier/ \
-DbaseURL=http://eclipse:8082/diva/rest/ \
-DuserId=coraUser:490742519075086 \
-DappToken=2e57eb36-55b9-4820-8c44-8271baab4e8e" \
cora-docker-synchronizer:1.0-SNAPSHOT
#can be called from host: http://localhost:38482/synchronizer/synchronizer/index?recordType=organisation&recordId=1

echo "starting solr"
docker run -d --name diva-cora-solr \
--network=eclipseForCoraNet \
-p 38985:8983 \
cora-solr:1.0-SNAPSHOT \
solr-precreate coracore /opt/solr/server/solr/configsets/coradefaultcore
docker start diva-cora-solr

echo "starting postgresql for fedora"
docker run -d --name diva-postgres-fcrepo --rm \
--net-alias=postgres-fcrepo \
-p 35434:5432 \
--network=eclipseForDivaNet \
-e POSTGRES_DB=fedora32 \
-e POSTGRES_USER=fedoraAdmin \
-e POSTGRES_PASSWORD=fedora \
diva-cora-docker-fcrepo-postgresql:1.1-SNAPSHOT postgres

echo "waiting 10s for postresql to start up"
sleep 10

echo "starting fedora"
docker run -d --name diva-docker-fedora --rm \
-p 38089:8088 \
-p 38445:8443 \
--network=eclipseForDivaNet \
diva-cora-docker-fedora-3.2.1:1.1-SNAPSHOT
#diva-cora-docker-fedora-3.2.1:1.0.0 /home/fedora/checkAndStart.sh

echo "connecting fedora docker to eclipseForCoraNet to access from tomcat and main application"
docker network connect eclipseForCoraNet diva-docker-fedora

echo "removing previous postgresql with diva mock data"
docker rm diva-docker-mock-classic-postgresql
echo "starting postgresql with diva mock data"
docker run -d --name diva-docker-mock-classic-postgresql --restart always  \
--net-alias=postgres-mock-classic-diva \
-p 35435:5432 \
--network=eclipseForDivaNet \
-e POSTGRES_DB=diva \
-e POSTGRES_USER=diva \
-e POSTGRES_PASSWORD=diva \
diva-docker-mock-classic-postgresql:1.0-SNAPSHOT

echo "connecting postgresql mock docker to eclipseForCoraNet to access from tomcat and main application"
docker network connect eclipseForCoraNet diva-docker-mock-classic-postgresql

echo "removing previous postgresql with diva data"
docker rm diva-cora-docker-postgresql
echo "starting postgresql with diva data"
docker run -d --name diva-cora-docker-postgresql --restart always  \
--net-alias=postgres-diva \
-p 35436:5432 \
--network=eclipseForDivaNet \
-e POSTGRES_DB=diva \
-e POSTGRES_USER=diva \
-e POSTGRES_PASSWORD=diva \
diva-cora-docker-postgresql:10.0-SNAPSHOT

echo "connecting postgresql docker to eclipseForCoraNet to access from tomcat and main application"
docker network connect eclipseForCoraNet diva-cora-docker-postgresql



echo "waiting 10s for postresql to start up"
sleep 10

echo "starting diva classic fedora synchronizer"
docker run -d  --name diva-classic-fedora-synchronizer \
--network=eclipseForCoraNet \
-e messaginghostname="diva-docker-fedora" \
-e messagingport="61616" \
-e messagingroutingKey="fedora.apim.update" \
-e messagingusername="fedoraAdmin" \
-e messagingpassword="fedora" \
-e databaseurl="jdbc:postgresql://diva-cora-docker-postgresql:5432/diva" \
-e databaseuser="diva" \
-e databasepassword="diva" \
-e fedorabaseUrl="http://diva-docker-fedora:8088/fedora/" \
-e coraapptokenVerifierUrl="http://eclipse:8182/apptokenverifier/" \
-e corabaseUrl="http://eclipse:8082/diva/rest/" \
-e corauserId="coraUser:490742519075086" \
-e coraapptoken="2e57eb36-55b9-4820-8c44-8271baab4e8e" \
diva-docker-classicfedorasynchronizer:1.0-SNAPSHOT


echo ""
echo "starting fitnesse HttpListener"
docker run -d --net=eclipseForCoraNet  -p 11111:11111 --name diva-fitnesse-httplistener \
diva-cora-docker-fitnesse:1.1-SNAPSHOT \
java -classpath /fitnesse/divacorafitnesse.jar \
se.uu.ub.cora.fitnesseintegration.httplistener.HttpListener 11111
