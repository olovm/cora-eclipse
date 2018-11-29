#! /bin/bash

echo "starting solr"
docker run -d --name diva-cora-solr \
--network=eclipseForCoraNet \
-p 8985:8983 \
cora-solr:0.3-SNAPSHOT \
solr-precreate coracore /opt/solr/server/solr/configsets/coradefaultcore
docker start diva-cora-solr

echo "starting postgresql for fedora"
docker run -d --name diva-postgres-fcrepo --rm \
--net-alias=postgres-fcrepo \
-p 5434:5432 \
--network=eclipseForDivaNet \
-e POSTGRES_DB=fedora38 \
-e POSTGRES_USER=fedoraAdmin \
-e POSTGRES_PASSWORD=fedora \
cora-docker-postgresql:9.6 postgres 

echo "waiting 10s for postresql to start up"
sleep 10

echo "starting fedora"
docker run -d --name diva-docker-fedora --rm \
--network=eclipseForDivaNet \
diva-cora-docker-fedora:3.8.1 /home/fedora/checkAndStart.sh

echo "connecting fedora docker to eclipseForCoraNet to access from tomcat and main application"
docker network connect eclipseForCoraNet diva-docker-fedora

echo "starting postgresql with diva data"
docker run -d --name diva-cora-docker-postgresql --restart always  \
--net-alias=postgres-diva \
-p 5435:5432 \
--network=eclipseForDivaNet \
-e POSTGRES_DB=diva \
-e POSTGRES_USER=diva \
-e POSTGRES_PASSWORD=diva \
diva-cora-docker-postgresql 