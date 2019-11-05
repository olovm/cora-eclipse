#! /bin/bash

echo "starting solr"
docker run -d --name alvin-cora-solr \
--network=eclipseForCoraNet \
-p 8984:8983 \
cora-solr:1.0-SNAPSHOT \
solr-precreate coracore /opt/solr/server/solr/configsets/coradefaultcore
docker start alvin-cora-solr

echo "starting postgresql for fedora"
docker run -d --name alvin-postgres-fcrepo --rm \
--net-alias=postgres-fcrepo \
-p 5433:5432 \
--network=eclipseForAlvinNet \
-e POSTGRES_DB=fedora38 \
-e POSTGRES_USER=fedoraAdmin \
-e POSTGRES_PASSWORD=fedora \
cora-docker-postgresql:9.6 postgres 

echo "waiting 10s for postresql to start up"
sleep 10

#docker run -d --name alvin-docker-fedora --rm \
echo "starting fedora"
docker run -d --name alvin-docker-fedora \
-p 8089:8088 \
-p 8444:8443 \
--network=eclipseForAlvinNet \
alvin-cora-docker-fedora-3.8.1:1.0.6 /home/fedora/checkAndStart.sh

echo "connecting fedora docker to eclipseForCoraNet to access from tomcat and main application"
docker network connect eclipseForCoraNet alvin-docker-fedora


#--net-alias=postgres-alvin \
echo "removing previous postgresql with Alvin data"
docker rm alvin-cora-docker-postgresql
echo "starting postgresql with Alvin data"
docker run -d --name alvin-cora-docker-postgresql --restart always  \
-p 5436:5432 \
--network=eclipseForAlvinNet \
-e POSTGRES_DB=alvin \
-e POSTGRES_USER=alvin \
-e POSTGRES_PASSWORD=alvin \
alvin-cora-docker-postgresql-9.6

echo "connecting postgresq docker to eclipseForCoraNet to access from tomcat and main application"
docker network connect eclipseForCoraNet alvin-cora-docker-postgresql