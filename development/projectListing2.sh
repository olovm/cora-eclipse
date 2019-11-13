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
#CORA_IMPLEMENTAITON="cora-basicdata  "

#PARENT, COMMON, CORA
LOGIN0="cora-gatekeepertokenprovider cora-apptokenstorage "
LOGIN_DEPLOYMENT="cora-idplogin cora-apptokenverifier "
LOGIN_CONTAINER="cora-docker-idplogin cora-docker-apptokenverifier "

#PARENT, COMMON, CORA
GATEKEEPER0="cora-gatekeeper "
GATEKEEPER_IMPLEMENTATION="cora-userpicker "
GATEKEEPER_DEPLOYMENT="cora-gatekeeperserver "
GATEKEEPER_CONTAINER="cora-docker-gatekeeper "

#PARENT, COMMON, CORA
CORE0="cora-storage cora-search cora-searchstorage cora-beefeater "
CORE1="cora-bookkeeper "
CORE2="cora-spider "
CORE3="cora-metacreator cora-gatekeeperclient "
CORE4="cora-therest "
CORE_DEPLOYMENT=""

#PARENT #COMMON
CLIENT0="cora-clientdata "
CLIENT1="cora-javaclient "


TIER5+=" cora-solrsearch cora-fedora "

#PARENT
JS="cora-jsclient  "
JS_CONTAINER="cora-docker-jsclient "


#PARENT, COMMON, CORA, CORE
STORAGE0="cora-sqldatabase cora-basicstorage cora-sqlstorage "


#PARENT #COMMON #CLIENT
INDEX0="cora-indexmessenger "

#PARENT #COMMON #CLIENT
VALIDATION0="cora-fitnesseintegration "

#PARENT, COMMON, CORA, CORE, STORAGE
#SYSTEMONE0="systemone-metadata systemone-basicstorage "
SYSTEMONE0="systemone-metadata "
SYSTEMONE_DEPLOYMENT="systemone "
SYSTEMONE_CONTAINER="systemone-docker systemone-docker-fitnesse "
SYSTEMONE_VALIDATION="cora-fitnesse "

#ALVIN0="alvin-metadata alvin-cora-fitnesse alvin-mixedstorage alvin-tocorastorage alvin-tocorautils  "
ALVIN0="alvin-metadata alvin-mixedstorage alvin-tocorautils "
ALVIN_DEPLOYMENT=" alvin-indexmessenger alvin-cora alvin-cora-fitnesse "
ALVIN_DEV_CONTAINER="alvin-cora-docker-fedora alvin-cora-docker-postgresql alvin-docker-index "
ALVIN_CONTAINER="alvin-docker-cora alvin-docker-gatekeeper alvin-cora-docker-fitnesse "

#DIVA0="diva-metadata diva-cora-fitnesse diva-mixedstorage diva-tocorastorage "
DIVA0="diva-metadata diva-mixedstorage "
DIVA1="diva-cora diva-cora-fitnesse diva-indexmessenger "
DIVA_DEV_CONTAINER="diva-cora-docker-fedora diva-cora-docker-postgresql diva-cora-docker-fcrepo-postgresql "
DIVA_CONTAINER="diva-docker-cora diva-docker-gatekeeper diva-cora-docker-fitnesse "

ALL_JAVA=$TIER0" "$TIER1" "$TIER2" "$TIER3" "$TIER4" "$TIER5" "$TIER6" "$TIER7" "$SYSTEMONE" "$ALVIN" "$DIVA

DEV_DOCKER=$CORA_DEV_DOCKER" "$ALVIN_DEV_DOCKER" "$DIVA_DEV_DOCKER

ALL=$ECLIPSE" "$ALL_JAVA" "$TIER6_JS" "$CORA_DOCKER" "$DEV_DOCKER" "$SYSTEMONE_DOCKER" "$ALVIN_DOCKER" "$DIVA_DOCKER
