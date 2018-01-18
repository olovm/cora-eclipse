#! /bin/bash

ECLIPSE="cora-eclipse"

TIER0="cora-parent"
TIER1="cora-json cora-httphandler cora-userpicker cora-apptokenstorage cora-searchstorage"
TIER2="cora-beefeater cora-bookkeeper cora-gatekeeper "
TIER3="cora-spider cora-gatekeepertokenprovider"
TIER4="cora-basicstorage cora-sqlstorage cora-gatekeeperclient cora-therest cora-apptokenverifier "
TIER4+="cora-idplogin cora-solrsearch"
TIER5="cora-metacreator cora-systemone "
TIER6="cora-fitnesseintegration cora-fitnesse "

TIER6_JS="cora-jsclient  "

CORA_DOCKER="cora-docker-gatekeeper cora-docker-apptokenverifier cora-docker-idplogin "
CORA_DOCKER+="cora-docker-solr cora-docker-therest cora-docker-fitnesse cora-docker-fedora "
CORA_DOCKER+="cora-docker-jsclient "


ALVIN="alvin-cora alvin-cora-fitnesse "
ALVIN_DOCKER="alvin-docker-cora alvin-docker-gatekeeper alvin-cora-docker-fitnesse "

DIVA="diva-cora diva-cora-fitnesse "
DIVA_DOCKER="diva-docker-cora diva-docker-gatekeeper diva-cora-docker-fitnesse "

ALL_JAVA=$TIER0" "$TIER1" "$TIER2" "$TIER3" "$TIER4" "$TIER5" "$TIER6" "$ALVIN" "$DIVA

ALL=$ECLIPSE" "$ALL_JAVA" "$TIER6_JS" "$CORA_DOCKER" "$ALVIN_DOCKER" "$DIVA_DOCKER
