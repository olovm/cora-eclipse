#! /bin/bash

echo "starting solr"
docker run -d --name alvin-cora-solr \
--network=eclipseForCoraNet \
-p 8984:8983 \
cora-solr:0.4-SNAPSHOT \
solr-precreate coracore /opt/solr/server/solr/configsets/coradefaultcore
docker start alvin-cora-solr

echo "starting postgresql for fedora"
docker run -d --name alvin-postgres-fcrepo --rm \
--net-alias=postgres-fcrepo \
-p 5432:5433 \
--network=eclipseForAlvinNet \
-e POSTGRES_DB=fedora38 \
-e POSTGRES_USER=fedoraAdmin \
-e POSTGRES_PASSWORD=fedora \
cora-docker-postgresql:9.6 postgres 

echo "waiting 10s for postresql to start up"
sleep 10

echo "starting fedora"
docker run -d --name alvin-docker-fedora --rm \
--network=eclipseForAlvinNet \
alvin-cora-docker-fedora:latest /home/fedora/checkAndStart.sh

echo "connecting fedora docker to eclipseForCoraNet to access from tomcat and main application"
docker network connect eclipseForCoraNet alvin-docker-fedora
