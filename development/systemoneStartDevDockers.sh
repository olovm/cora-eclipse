#! /bin/bash

echo "starting solr"
docker run -d --name systemone-cora-solr \
--network=eclipseForCoraNet \
cora-solr:0.2-SNAPSHOT \
solr-precreate coracore /opt/solr/server/solr/configsets/coradefaultcore
docker start systemone-cora-solr

