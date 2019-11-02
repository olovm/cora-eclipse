#! /bin/bash

ECLIPSE="cora-eclipse"

PARENT0="cora-parent "

#PARENT
COMMON1="cora-logger "
COMMON2="cora-httphandler cora-json cora-messaging "
COMMON_IMPLEMENTATION="cora-log4j cora-activemq cora-rabbitmq "

#PARENT
CORA_PURE_CONTAINER="cora-docker-solr cora-docker-fedora cora-docker-fedora32 cora-docker-postgresql "

#PARENT, COMMON
CORA0="cora-metadata cora-data "

#PARENT, COMMON, CORA
GATEKEEPER0="cora-gatekeeper "
GATEKEEPER_IMPLEMENTATION="cora-userpicker "
GATEKEEPER_DEPLOYMENT="cora-gatekeeperserver "
GATEKEEPER_CONTAINER="cora-docker-gatekeeper "

#PARENT, COMMON, CORA
LOGIN0="cora-gatekeepertokenprovider cora-apptokenstorage "
LOGIN_DEPLOYMENT="cora-idplogin cora-apptokenverifier "
LOGIN_CONTAINER="cora-docker-idplogin cora-docker-apptokenverifier "

#PARENT, COMMON, CORA
THEREST0="cora-storage cora-search cora-searchstorage cora-beefeater "
THEREST1="cora-bookkeeper "
THEREST2="cora-spider "
THEREST3="cora-metacreator cora-gatekeeperclient "
THEREST4="cora-therest "

THEREST_DEPLOYMENT=""

#COMMON
CLIENT0="cora-clientdata "
CLIENT1="cora-javaclient "

TIER2+=" cora-sqldatabase "
TIER3="  "
#TIER4="cora-basicdata cora-searchstorage cora-spider cora-gatekeepertokenprovider "
TIER4="  "
TIER5="cora-basicstorage cora-sqlstorage    "
TIER5+=" cora-solrsearch cora-fedora "
TIER6="  cora-indexmessenger "
TIER7="cora-fitnesseintegration cora-fitnesse   "

JS="cora-jsclient  "

CORA_DOCKER=" "
CORA_DOCKER+="cora-docker-jsclient "

SYSTEMONE0="systemone-metadata systemone-basicstorage "
SYSTEMONE1="systemone "
SYSTEMONE_DOCKER="systemone-docker systemone-docker-fitnesse "

ALVIN0="alvin-metadata alvin-cora-fitnesse alvin-mixedstorage alvin-tocorastorage alvin-tocorautils  "
ALVIN1=" alvin-indexmessenger alvin-cora"
ALVIN_DEV_DOCKER="alvin-cora-docker-fedora alvin-cora-docker-postgresql alvin-docker-index "
ALVIN_DOCKER="alvin-docker-cora alvin-docker-gatekeeper alvin-cora-docker-fitnesse "

DIVA0="diva-metadata diva-cora-fitnesse diva-mixedstorage diva-tocorastorage "
DIVA1="diva-cora "
DIVA_DEV_DOCKER="diva-cora-docker-fedora diva-cora-docker-postgresql diva-cora-docker-fcrepo-postgresql "
DIVA_DOCKER="diva-docker-cora diva-docker-gatekeeper diva-cora-docker-fitnesse "

ALL_JAVA=$TIER0" "$TIER1" "$TIER2" "$TIER3" "$TIER4" "$TIER5" "$TIER6" "$TIER7" "$SYSTEMONE" "$ALVIN" "$DIVA

DEV_DOCKER=$CORA_DEV_DOCKER" "$ALVIN_DEV_DOCKER" "$DIVA_DEV_DOCKER

ALL=$ECLIPSE" "$ALL_JAVA" "$TIER6_JS" "$CORA_DOCKER" "$DEV_DOCKER" "$SYSTEMONE_DOCKER" "$ALVIN_DOCKER" "$DIVA_DOCKER
