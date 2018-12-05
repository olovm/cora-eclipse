#! /bin/bash

ECLIPSE="cora-eclipse"

TIER0="cora-parent "
TIER1="cora-json cora-httphandler cora-userpicker cora-apptokenstorage cora-searchstorage cora-sqldatabase"
TIER2="cora-beefeater cora-bookkeeper cora-gatekeeper "
TIER3="cora-spider cora-gatekeepertokenprovider"
TIER4="cora-basicstorage cora-sqlstorage cora-gatekeeperclient cora-therest cora-apptokenverifier "
TIER4+="cora-idplogin cora-solrsearch cora-metacreator cora-fedora "
TIER5="cora-clientdata "
TIER6="cora-fitnesseintegration cora-fitnesse cora-systemone cora-javaclient cora-metadata systemone-metadata "

TIER6_JS="cora-jsclient  "

CORA_DOCKER="cora-docker-gatekeeper cora-docker-apptokenverifier cora-docker-idplogin "
CORA_DEV_DOCKER="cora-docker-solr cora-docker-fedora cora-docker-postgresql "
CORA_DOCKER+="cora-docker-therest cora-docker-fitnesse "
CORA_DOCKER+="cora-docker-jsclient "


ALVIN="alvin-cora-fitnesse alvin-mixedstorage alvin-tocorastorage alvin-tocorautils alvin-cora alvin-metadata "
ALVIN_DEV_DOCKER="alvin-cora-docker-fedora  alvin-cora-docker-postgresql "
ALVIN_DOCKER="alvin-docker-cora alvin-docker-gatekeeper alvin-cora-docker-fitnesse "

DIVA="diva-cora-fitnesse diva-mixedstorage diva-tocorastorage diva-cora diva-metadata"
DIVA_DEV_DOCKER="diva-cora-docker-fedora diva-cora-docker-postgresql "
DIVA_DOCKER="diva-docker-cora diva-docker-gatekeeper diva-cora-docker-fitnesse "

ALL_JAVA=$TIER0" "$TIER1" "$TIER2" "$TIER3" "$TIER4" "$TIER5" "$TIER6" "$ALVIN" "$DIVA

DEV_DOCKER=$CORA_DEV_DOCKER" "$ALVIN_DEV_DOCKER" "$DIVA_DEV_DOCKER

ALL=$ECLIPSE" "$ALL_JAVA" "$TIER6_JS" "$CORA_DOCKER" "$DEV_DOCKER" "$ALVIN_DOCKER" "$DIVA_DOCKER
