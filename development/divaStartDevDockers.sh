#! /bin/bash

echo "starting solr"
docker run -d --name diva-cora-solr \
--network=eclipseForCoraNet \
-p 8985:8983 \
cora-solr:1.0-SNAPSHOT \
solr-precreate coracore /opt/solr/server/solr/configsets/coradefaultcore
docker start diva-cora-solr

echo "starting postgresql for fedora"
docker run -d --name diva-postgres-fcrepo --rm \
--net-alias=postgres-fcrepo \
-p 5434:5432 \
--network=eclipseForDivaNet \
-e POSTGRES_DB=fedora32 \
-e POSTGRES_USER=fedoraAdmin \
-e POSTGRES_PASSWORD=fedora \
diva-cora-docker-fcrepo-postgresql:1.0.0 postgres 

echo "waiting 10s for postresql to start up"
sleep 10

echo "starting fedora"
docker run -d --name diva-docker-fedora --rm \
-p 38089:8088 \
-p 8445:8443 \
--network=eclipseForDivaNet \
diva-cora-docker-fedora-3.2.1:1.0.2
#diva-cora-docker-fedora-3.2.1:1.0.0 /home/fedora/checkAndStart.sh

echo "connecting fedora docker to eclipseForCoraNet to access from tomcat and main application"
docker network connect eclipseForCoraNet diva-docker-fedora

echo "removing previous postgresql with diva data"
docker rm diva-cora-docker-postgresql
echo "starting postgresql with diva data"
docker run -d --name diva-cora-docker-postgresql --restart always  \
--net-alias=postgres-diva \
-p 5435:5432 \
--network=eclipseForDivaNet \
-e POSTGRES_DB=diva \
-e POSTGRES_USER=diva \
-e POSTGRES_PASSWORD=diva \
diva-cora-docker-postgresql 

echo "connecting postgresq docker to eclipseForCoraNet to access from tomcat and main application"
docker network connect eclipseForCoraNet diva-cora-docker-postgresql

