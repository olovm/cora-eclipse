#! /bin/bash

echo "starting solr"
docker run -d --name alvin-cora-solr \
--network=eclipseForCoraNet \
-p 38984:8983 \
cora-solr:1.0-SNAPSHOT \
solr-precreate coracore /opt/solr/server/solr/configsets/coradefaultcore
docker start alvin-cora-solr

#docker run -d --name alvin-docker-fedora --rm \
echo "starting fedora"
docker run -d --name alvin-docker-fedora \
-p 38088:8080 \
--network=eclipseForAlvinNet \
cora-docker-fedora:1.0-SNAPSHOT

echo "connecting fedora docker to eclipseForCoraNet to access from tomcat and main application"
docker network connect eclipseForCoraNet alvin-docker-fedora


echo "removing previous postgresql with cora data"
docker rm systemone-docker-postgresql
echo "starting postgresql with cora data"
docker run -d --name systemone-docker-postgresql --restart always  \
--net-alias=postgres-systemone \
-p 35432:5432 \
--network=eclipseForCoraNet \
-e POSTGRES_DB=systemone \
-e POSTGRES_USER=systemone \
-e POSTGRES_PASSWORD=systemone \
systemone-docker-postgresql:1.0-SNAPSHOT

echo "connecting postgresq docker to eclipseForCoraNet to access from tomcat and main application"
docker network connect eclipseForCoraNet alvin-docker-postgresql
