#! /bin/bash

TIER_ECLIPSE="cora-eclipse"

TIER0="cora-parent"
TIER1="cora-json cora-httphandler cora-userpicker cora-apptokenstorage cora-searchstorage"
TIER2="cora-beefeater cora-bookkeeper cora-gatekeeper "
TIER3="cora-spider cora-gatekeepertokenprovider"
TIER4="cora-basicstorage cora-sqlstorage cora-gatekeeperclient cora-therest cora-apptokenverifier cora-solrsearch"
TIER5="cora-metacreator cora-systemone "
#TIER6="cora-jsclient cora-fitnesse "
TIER6_JS="cora-jsclient  "
TIER6="cora-fitnesse "


TIER_DOCKER="cora-docker-gatekeeper cora-docker-apptokenverifier "
TIER_DOCKER+="cora-docker-solr cora-docker-therest cora-docker-fitnesse "

ALL_JAVA=$TIER0" "$TIER1" "$TIER2" "$TIER3" "$TIER4" "$TIER5" "$TIER6

ALL=$TIER_ECLIPSE" "$ALL_JAVA" "$TIER6_JS" "$TIER_DOCKER
