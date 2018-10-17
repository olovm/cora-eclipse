#! /bin/bash

echo "starting solr"
docker run -d --name diva-cora-solr \
--network=eclipseForCoraNet \
-p 8983:8985 \
cora-solr:0.2-SNAPSHOT \
solr-precreate coracore /opt/solr/server/solr/configsets/coradefaultcore
docker start diva-cora-solr

echo "starting postgresql for fedora"
docker run -d --name diva-postgres-fcrepo --rm \
--net-alias=postgres-fcrepo \
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
diva-cora-docker-fedora:latest /home/fedora/checkAndStart.sh

echo "connecting fedora docker to eclipseForCoraNet to access from tomcat and main application"
docker network connect eclipseForCoraNet diva-docker-fedora
