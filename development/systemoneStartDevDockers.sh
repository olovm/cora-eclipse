#! /bin/bash

echo "starting solr"
docker run -d --name systemone-cora-solr \
--network=eclipseForCoraNet \
-p 38983:8983 \
cora-solr:1.0-SNAPSHOT \
solr-precreate coracore /opt/solr/server/solr/configsets/coradefaultcore
docker start systemone-cora-solr

#docker run -d --name systemone-docker-fedora --rm \
echo "starting fedora"
docker run -d --name systemone-docker-fedora \
-p 38087:8080 \
--network=eclipseForCoraNet \
cora-docker-fedora:1.0-SNAPSHOT