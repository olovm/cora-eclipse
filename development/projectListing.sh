#! /bin/bash

ECLIPSE="cora-eclipse "

PARENT0="cora-parent "

#PARENT
COMMON1="cora-testutils cora-testutils-spies cora-logger cora-logger-spies cora-initialize cora-initialize-spies "
COMMON2="cora-httphandler cora-httphandler-spies cora-json cora-messaging cora-password "
COMMON_IMPLEMENTATION="cora-log4j cora-activemq cora-rabbitmq "
ALL_COMMON=$COMMON1" "$COMMON2" "$COMMON_IMPLEMENTATION

#PARENT
COMMON_PURE_CONTAINER="cora-docker-tomcat cora-docker-java cora-docker-solr cora-docker-postgresql "
COMMON_PURE_CONTAINER+="cora-docker-fedora cora-docker-fedora32 cora-docker-fedora32-client cora-docker-fedora38 "
#PARENT, COMMON
CORA0="cora-metadata cora-data cora-data-spies "
CORA1="cora-converter "
CORA_IMPLEMENTATION="cora-xmlutils cora-xmlconverter cora-basicdata "
ALL_CORA=$CORA0" "$CORA1" "$CORA_IMPLEMENTATION

#PARENT, COMMON, CORA
CORE0="cora-beefeater cora-bookkeeper cora-storage cora-storage-spies "
CORE1="cora-search cora-searchstorage "
CORE2="cora-spider cora-spider-spies cora-metadatastorage "
CORE3="cora-metacreator cora-gatekeeperclient cora-fedora cora-fedora3x"
CORE4="cora-therest "
ALL_CORE=$CORE0" "$CORE1" "$CORE2" "$CORE3" "$CORE4

#PARENT, COMMON, CORA
LOGIN0="cora-gatekeepertokenprovider "
LOGIN_DEPLOYMENT="cora-idplogin cora-apptokenverifier cora-apptokenverifier-war "
LOGIN_CONTAINER="cora-docker-idplogin cora-docker-apptokenverifier "
#ALL_LOGIN=$LOGIN0" "$LOGIN_DEPLOYMENT
ALL_LOGIN=$LOGIN0

#PARENT, COMMON, CORA
GATEKEEPER0="cora-gatekeeper "
GATEKEEPER_IMPLEMENTATION="cora-userstorage cora-userpicker "
GATEKEEPER_DEPLOYMENT="cora-gatekeeperserver "
#ALL_GATEKEEPER=$GATEKEEPER0" "$GATEKEEPER_IMPLEMENTATION" "$GATEKEEPER_DEPLOYMENT
ALL_GATEKEEPER=$GATEKEEPER0" "$GATEKEEPER_IMPLEMENTATION


#PARENT #COMMON
CLIENT0="cora-clientdata "
CLIENT1="cora-javaclient "
ALL_CLIENT=$CLIENT0" "$CLIENT1

#PARENT
JS="cora-jsclient "
JS_CONTAINER="cora-docker-jsclient "
ALL_JS=$JS" "$JS_CONTAINER

#PARENT, COMMON, CORA, CORE
STORAGE0="cora-sqldatabase cora-basicstorage cora-sqlstorage cora-fedoraarchive "
ALL_STORAGE=$STORAGE0

#PARENT, COMMON, CORA, CORE
SEARCH0="cora-solrsearch "
ALL_SEARCH=$SEARCH0

#PARENT #COMMON #CLIENT
INDEX0="cora-indexmessenger cora-synchronizer cora-classicfedorasynchronizer "
INDEX_CONTAINER="cora-docker-synchronizer "
#ALL_INDEX=$INDEX0" "$INDEX_DEPLOYMENT
ALL_INDEX=$INDEX0

#PARENT #COMMON #CLIENT
VALIDATION0="cora-fitnesseintegration "
ALL_VALIDATION=$VALIDATION0

#PARENT, COMMON, CORA, CORE, STORAGE
SYSTEMONE0="systemone-metadata "
SYSTEMONE_DEPLOYMENT="systemone systemone-gatekeeper-war "
SYSTEMONE_VALIDATION="cora-fitnesse "
SYSTEMONE_CONTAINER="cora-docker-gatekeeper systemone-docker systemone-docker-fitnesse "
ALL_SYSTEMONE=$SYSTEMONE0" "$SYSTEMONE_DEPLOYMENT" "$SYSTEMONE_VALIDATION

#PARENT, COMMON, CORA, CORE, STORAGE
ALVIN0="alvin-metadata alvin-mixedstorage alvin-tocorautils "
ALVIN_DEPLOYMENT="alvin-cora alvin-gatekeeper-war alvin-indexmessenger "
ALVIN_VALIDATION="alvin-cora-fitnesse "
ALVIN_DEV_CONTAINER="alvin-cora-docker-fedora alvin-cora-docker-postgresql alvin-docker-index "
ALVIN_CONTAINER="alvin-docker-cora alvin-docker-gatekeeper alvin-cora-docker-fitnesse "
ALL_ALVIN=$ALVIN0" "$ALVIN_DEPLOYMENT" "$ALVIN_VALIDATION

#PARENT, COMMON, CORA, CORE, STORAGE
DIVA0="diva-metadata diva-mixedstorage "
DIVA_DEPLOYMENT="diva-cora diva-gatekeeper-war diva-indexmessenger "
DIVA_VALIDATION="diva-cora-fitnesse "
DIVA_DEV_CONTAINER0="diva-cora-docker-fedora diva-docker-mock-classic-postgresql "
DIVA_DEV_CONTAINER1="diva-cora-docker-postgresql diva-cora-docker-fcrepo-postgresql "
DIVA_DEV_CONTAINER2="diva-docker-classicfedorasynchronizer diva-cora-docker-fitnesse "
DIVA_CONTAINER="diva-docker-cora diva-docker-gatekeeper diva-docker-index "
DIVA_DEV_CONTAINER=$DIVA_DEV_CONTAINER0" "$DIVA_DEV_CONTAINER1" "$DIVA_DEV_CONTAINER2
ALL_DIVA=$DIVA0" "$DIVA_DEPLOYMENT" "$DIVA_VALIDATION


ALL_JAVA=$PARENT0" "$ALL_COMMON" "$ALL_CORA" "$ALL_LOGIN" "$ALL_GATEKEEPER" "$ALL_CORE" "
ALL_JAVA+=$ALL_CLIENT" "$ALL_STORAGE" "$ALL_SEARCH" "$ALL_INDEX" "$ALL_VALIDATION" "
ALL_JAVA+=$INDEX_DEPLOYMENT" "$LOGIN_DEPLOYMENT" "$GATEKEEPER_DEPLOYMENT" "
ALL_JAVA+=$ALL_SYSTEMONE" "$ALL_ALVIN" "$ALL_DIVA

DEV_CONTAINER=$COMMON_PURE_CONTAINER" "$INDEX_CONTAINER" "$ALVIN_DEV_CONTAINER" "$DIVA_DEV_CONTAINER

SERVER_CONTAINER=$LOGIN_CONTAINER" "$SYSTEMONE_CONTAINER" "$ALVIN_CONTAINER" "$DIVA_CONTAINER

OTHER="friday-monitoring cora-utils cora-jenkins cora-indexloader"

ALL=$ECLIPSE" "$ALL_JAVA" "$ALL_JS" "$DEV_CONTAINER" "$SERVER_CONTAINER" "$OTHER
