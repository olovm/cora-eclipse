#! /bin/bash

echo "starting solr"
docker run -d --name diva-solr \
--network=eclipseForCoraNet \
-p 38985:8983 \
cora-solr:1.0-SNAPSHOT \
solr-precreate coracore /opt/solr/server/solr/configsets/coradefaultcore

echo ""
#$sharedArchive is set when starting eclipse docker
echo "using host location $sharedArchive/diva in the eclipse docker mounted on"
echo "/tmp/sharedArchive to store the files for the archive to be able to read it from fitnesse "
echo "using path /tmp/sharedArchive/diva."
#docker run -d --name diva-docker-fedora --rm \
echo "starting fedora"
docker run -d --name diva-fedora \
-p 38089:8080 \
--network=eclipseForCoraNet \
--mount type=bind,source=$sharedArchive/diva,target=/usr/local/tomcat/fcrepo-home/data/ocfl-root,bind-propagation=shared \
cora-docker-fedora:1.0-SNAPSHOT

echo "removing previous postgresql with cora data"
docker rm diva-postgresql
echo "starting postgresql with cora data"
docker run -d --name diva-postgresql --restart always  \
-p 35434:5432 \
--network=eclipseForCoraNet \
-e POSTGRES_DB=diva \
-e POSTGRES_USER=diva \
-e POSTGRES_PASSWORD=diva \
diva-docker-postgresql:1.0-SNAPSHOT

echo "connecting postgresql docker to eclipseForCoraNet to access from tomcat and main application"
docker network connect eclipseForCoraNet diva-postgresql