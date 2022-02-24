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


#--net-alias=postgres-alvin \
echo "removing previous postgresql with Alvin data"
docker rm alvin-cora-docker-postgresql
echo "starting postgresql with Alvin data"
docker run -d --name alvin-cora-docker-postgresql --restart always  \
-p 35436:5432 \
--network=eclipseForAlvinNet \
-e POSTGRES_DB=alvin \
-e POSTGRES_USER=alvin \
-e POSTGRES_PASSWORD=alvin \
alvin-cora-docker-postgresql-9.6

echo "connecting postgresq docker to eclipseForCoraNet to access from tomcat and main application"
docker network connect eclipseForCoraNet alvin-cora-docker-postgresql