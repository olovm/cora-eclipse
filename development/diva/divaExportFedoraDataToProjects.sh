#! /bin/bash
SCRIPT=$(readlink -f "$0")
RUNNINGFROMDIR=$(dirname $SCRIPT)
WORKSPACEDIR=$RUNNINGFROMDIR/../../..

echo "creating temp dir for exported files"
mkdir $WORKSPACEDIR/diva-cora-docker-fedora/docker/expData/home/fedora/fedora32/data/objects/ -p

echo "copy files from running fedora docker"
docker cp diva-docker-fedora:/home/fedora/fedora32/data/objects $WORKSPACEDIR/diva-cora-docker-fedora/docker/expData/home/fedora/fedora32/data/

echo "pack files to data.tar.gz"
tar -zcvf $WORKSPACEDIR/diva-cora-docker-fedora/docker/data.tar.gz -C $WORKSPACEDIR/diva-cora-docker-fedora/docker/expData .

echo "remove temp files"
rm -rf $WORKSPACEDIR/diva-cora-docker-fedora/docker/expData

echo WORKSPACEDIR: $WORKSPACEDIR

echo "Create db dump"
docker exec diva-postgres-fcrepo bash -c "pg_dump -U fedoraAdmin fedora32 > /data/fedora32.sql"

echo "copy db dump from running postgresql docker"
docker cp diva-postgres-fcrepo:/data/fedora32.sql $WORKSPACEDIR/diva-cora-docker-fcrepo-postgresql/docker/data/


echo
echo
echo
echo
echo "Check that data.tar.gz is updated in diva-cora-docker-fedora project"
echo "Check that fedora32.sql is updated in diva-cora-docker-fcrepo-postgresql project"

### export database data:
#docker exec -it diva-postgres-fcrepo bash
#pg_dump -U fedoraAdmin fedora32 > /temp/fedora32.sql

#export dumped file from db docker 
#host directory: /home/olov/workspace/diva-cora-docker-fedora/docker/expDBData
#container path:  /temp/