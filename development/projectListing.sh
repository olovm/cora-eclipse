#! /bin/bash

TIER_ECLIPSE="cora-eclipse"

TIER0="cora-parent"
TIER1="cora-json cora-httphandler cora-userpicker cora-apptokenstorage cora-searchstorage"
TIER2="cora-beefeater cora-bookkeeper cora-gatekeeper "
TIER3="cora-spider cora-gatekeepertokenprovider"
TIER4="cora-basicstorage cora-sqlstorage cora-gatekeeperclient cora-therest cora-apptokenverifier "
TIER4+="cora-idplogin cora-solrsearch"
TIER5="cora-metacreator cora-systemone "
#TIER6="cora-jsclient cora-fitnesse "
TIER6_JS="cora-jsclient  "
TIER6="cora-fitnesse "

TIER_ALVIN="alvin-cora "


TIER_DOCKER="cora-docker-gatekeeper cora-docker-apptokenverifier cora-docker-idplogin "
TIER_DOCKER+="cora-docker-solr cora-docker-therest cora-docker-fitnesse "

ALL_JAVA=$TIER0" "$TIER1" "$TIER2" "$TIER3" "$TIER4" "$TIER5" "$TIER6" "$TIER_ALVIN

ALL=$TIER_ECLIPSE" "$ALL_JAVA" "$TIER6_JS" "$TIER_DOCKER
