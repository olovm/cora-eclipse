#! /bin/bash

echo "starting solr"
docker run -d --name systemone-cora-solr \
--network=eclipseForCoraNet \
-p 38983:8983 \
cora-solr:1.0-SNAPSHOT \
solr-precreate coracore /opt/solr/server/solr/configsets/coradefaultcore
docker start systemone-cora-solr

echo ""
#$sharedArchive is set when starting eclipse docker
echo "using host location $sharedArchive/systemOne in the eclipse docker mounted on"
echo "/tmp/sharedArchive to store the files for the archive to be able to read it from fitnesse "
echo "using path /tmp/sharedArchive/systemOne."
#docker run -d --name systemone-docker-fedora --rm \
echo "starting fedora"
docker run -d --name systemone-docker-fedora \
-p 38087:8080 \
--network=eclipseForCoraNet \
--mount type=bind,source=$sharedArchive/systemOne,target=/usr/local/tomcat/fcrepo-home/data/ocfl-root,bind-propagation=shared \
cora-docker-fedora:1.0-SNAPSHOT

echo "removing previous postgresql with cora data"
docker rm systemone-cora-docker-postgresql
echo "starting postgresql with cora data"
docker run -d --name systemone-cora-docker-postgresql --restart always  \
--net-alias=postgres-systemone \
-p 35432:5432 \
--network=eclipseForCoraNet \
-e POSTGRES_DB=systemone \
-e POSTGRES_USER=systemone \
-e POSTGRES_PASSWORD=systemone \
cora-docker-postgresql:11.0-SNAPSHOT

#--mount type=bind,source=/mnt/depot/cora/sharedArchive,target=/usr/local/tomcat/fcrepo-home/data/ocfl-root,bind-propagation=shared \

#--volumes-from eclipse202209forcora1 \