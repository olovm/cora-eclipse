#! /bin/bash

echo "starting solr"
docker run -d --name alvin-solr \
--network=eclipseForCoraNet \
-p 38984:8983 \
cora-solr:1.0-SNAPSHOT \
solr-precreate coracore /opt/solr/server/solr/configsets/coradefaultcore

#docker run -d --name alvin-docker-fedora --rm \
echo "starting fedora"
docker run -d --name alvin-fedora \
-p 38088:8080 \
--network=eclipseForAlvinNet \
cora-docker-fedora:1.0-SNAPSHOT

echo "connecting fedora docker to eclipseForCoraNet to access from tomcat and main application"
docker network connect eclipseForCoraNet alvin-fedora


echo "removing previous postgresql with cora data"
docker rm alvin-postgresql
echo "starting postgresql with cora data"
docker run -d --name alvin-postgresql --restart always  \
-p 35433:5432 \
--network=eclipseForAlvinNet \
-e POSTGRES_DB=alvin \
-e POSTGRES_USER=alvin \
-e POSTGRES_PASSWORD=alvin \
alvin-docker-postgresql:1.0-SNAPSHOT

echo "connecting postgresql docker to eclipseForCoraNet to access from tomcat and main application"
docker network connect eclipseForCoraNet alvin-postgresql
