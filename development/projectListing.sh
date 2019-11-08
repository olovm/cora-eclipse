#! /bin/bash

ECLIPSE="cora-eclipse"

TIER0="cora-parent "
TIER1="cora-logger cora-messaging "
TIER1+="cora-data cora-json cora-httphandler cora-userpicker cora-apptokenstorage cora-sqldatabase "
TIER2="cora-storage cora-search cora-beefeater cora-bookkeeper cora-gatekeeper cora-gatekeeperserver "
#TIER3="cora-basicdata cora-searchstorage cora-spider cora-gatekeepertokenprovider "
TIER3=" cora-searchstorage cora-spider cora-gatekeepertokenprovider "
TIER4="cora-basicstorage cora-sqlstorage cora-gatekeeperclient cora-therest cora-apptokenverifier "
TIER4+="cora-idplogin cora-solrsearch cora-metacreator cora-fedora "
TIER5="cora-clientdata cora-log4j cora-activemq cora-rabbitmq cora-indexmessenger "
TIER6="cora-fitnesseintegration cora-fitnesse cora-javaclient cora-metadata systemone-metadata "

TIER6_JS="cora-jsclient  "

CORA_DOCKER="cora-docker-gatekeeper cora-docker-apptokenverifier cora-docker-idplogin "
CORA_DOCKER+="cora-docker-jsclient "
CORA_DEV_DOCKER="cora-docker-solr cora-docker-fedora cora-docker-fedora32 cora-docker-postgresql "

SYSTEMONE="systemone systemone-basicstorage "
SYSTEMONE_DOCKER="systemone-docker systemone-docker-fitnesse "

ALVIN="alvin-cora-fitnesse alvin-mixedstorage alvin-tocorastorage alvin-tocorautils alvin-cora "
ALVIN+="alvin-metadata alvin-indexmessenger "
ALVIN_DEV_DOCKER="alvin-cora-docker-fedora alvin-cora-docker-postgresql alvin-docker-index "
ALVIN_DOCKER="alvin-docker-cora alvin-docker-gatekeeper alvin-cora-docker-fitnesse "

DIVA="diva-cora-fitnesse diva-mixedstorage diva-tocorastorage diva-cora diva-metadata "
DIVA+="diva-indexmessenger "
DIVA_DEV_DOCKER="diva-cora-docker-fedora diva-cora-docker-postgresql diva-cora-docker-fcrepo-postgresql "
DIVA_DOCKER="diva-docker-cora diva-docker-gatekeeper diva-cora-docker-fitnesse "

ALL_JAVA=$TIER0" "$TIER1" "$TIER2" "$TIER3" "$TIER4" "$TIER5" "$TIER6" "$SYSTEMONE" "$ALVIN" "$DIVA

DEV_DOCKER=$CORA_DEV_DOCKER" "$ALVIN_DEV_DOCKER" "$DIVA_DEV_DOCKER

ALL=$ECLIPSE" "$ALL_JAVA" "$TIER6_JS" "$CORA_DOCKER" "$DEV_DOCKER" "$SYSTEMONE_DOCKER" "$ALVIN_DOCKER" "$DIVA_DOCKER
