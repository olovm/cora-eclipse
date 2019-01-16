#! /bin/bash

echo "starting solr"
docker run -d --name systemone-cora-solr \
--network=eclipseForCoraNet \
-p 8983:8983 \
cora-solr:0.4-SNAPSHOT \
solr-precreate coracore /opt/solr/server/solr/configsets/coradefaultcore
docker start systemone-cora-solr

