#! /bin/bash

echo "starting diva synchronizer"
docker run -d --name diva-docker-synchronizer --rm \
-p 38482:8080 \
--network=eclipseForCoraNet \
--network-alias=synchronizer \
-e "JAVA_OPTS=\
-DapptokenVerifierURL=http://eclipse202109forcora2:8182/apptokenverifier/ \
-DbaseURL=http://eclipse202109forcora2:8082/diva/rest/ \
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

echo "starting diva indexer"
docker run -d  --name diva-docker-index -rm \
--restart unless-stopped \
--network=eclipseForCoraNet \
--network-alias=indexer \
-e hostname="diva-docker-fedora" \
-e port="61616" \
-e routingKey="fedora.apim.update" \
-e username="fedoraAdmin" \
-e password="fedora" \
-e appTokenVerifierUrl="http://eclipse202109forcora2:8182/apptokenverifier/" \
-e baseUrl="http://eclipse202109forcora2:8082/diva/rest/" \
-e userId="coraUser:490742519075086" \
-e appToken="2e57eb36-55b9-4820-8c44-8271baab4e8e" \
diva-docker-index:1.0-SNAPSHOT
#can be called from host: http://localhost:38482/synchronizer/synchronizer/index?recordType=organisation&recordId=1

