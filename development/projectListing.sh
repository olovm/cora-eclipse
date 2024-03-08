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
COMMON_PURE_CONTAINER+="cora-docker-fedora cora-docker-rabbitmq cora-docker-iipimageserver "
#ARCHIVED="cora-docker-fedora32 cora-docker-fedora32-client cora-docker-fedora38 "
#PARENT, COMMON
CORA0="cora-metadata cora-data cora-data-spies "
CORA1="cora-converter cora-iiif "
CORA_IMPLEMENTATION="cora-xmlutils cora-xmlconverter cora-basicdata "
ALL_CORA=$CORA0" "$CORA1" "$CORA_IMPLEMENTATION

#PARENT, COMMON, CORA
CORE0="cora-beefeater cora-bookkeeper cora-storage cora-storage-spies "
CORE1="cora-search cora-searchstorage cora-contentanalyzer "
CORE2="cora-spider cora-spider-spies cora-metadatastorage "
CORE3="cora-metacreator cora-gatekeeperclient cora-fedora cora-tikacontentanalyzer"
#ARCHIVED="cora-fedora3x "

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
CLIENT0="cora-clientdata cora-clientdata-spies cora-basicclientdata"
CLIENT1="cora-javaclient cora-change"
ALL_CLIENT=$CLIENT0" "$CLIENT1

#PARENT
JS="cora-jsclient "
JS_CONTAINER="cora-docker-jsclient "
ALL_JS=$JS" "$JS_CONTAINER

#PARENT, COMMON, CORA, CORE
STORAGE0="cora-sqldatabase cora-basicstorage cora-sqlstorage cora-fedoraarchive "
ALL_STORAGE=$STORAGE0

#PARENT, COMMON, CORA, STORAGE
BINARYCONVERTER0="cora-binaryconverter "
BINARYCONVERTER_IMPLEMENTATION=" "
BINARYCONVERTER_DEPLOYMENT=" "
BINARYCONVERTER_CONTAINER="cora-docker-binaryconverter "
#ALL_BINARYCONVERTER=$BINARYCONVERTER0" "$BINARYCONVERTER_IMPLEMENTATION
ALL_BINARYCONVERTER=$BINARYCONVERTER0" "

#PARENT, COMMON, CORA, CORE
SEARCH0="cora-solrsearch "
ALL_SEARCH=$SEARCH0

#PARENT #COMMON #CLIENT
#ARCHIVED="INDEX0="cora-indexmessenger cora-synchronizer cora-classicfedorasynchronizer "
#ARCHIVED="INDEX_CONTAINER="cora-docker-synchronizer "
#ALL_INDEX=$INDEX0" "$INDEX_DEPLOYMENT
#ALL_INDEX=$INDEX0

#PARENT #COMMON #CLIENT
VALIDATION0="cora-fitnesseintegration "
ALL_VALIDATION=$VALIDATION0

#PARENT, COMMON, CORA, CORE, STORAGE
SYSTEMONE0="systemone-metadata "
SYSTEMONE_DEPLOYMENT="systemone systemone-gatekeeper-war "
SYSTEMONE_VALIDATION="cora-fitnesse "
SYSTEMONE_DEV_CONTAINER="systemone-docker-postgresql "
SYSTEMONE_CONTAINER="cora-docker-gatekeeper systemone-docker systemone-docker-fitnesse "
ALL_SYSTEMONE=$SYSTEMONE0" "$SYSTEMONE_DEPLOYMENT" "$SYSTEMONE_VALIDATION

#PARENT, COMMON, CORA, CORE, STORAGE
ALVIN0="alvin-metadata "
#ARCHIVED="alvin-mixedstorage alvin-tocorautils "
ALVIN_DEPLOYMENT="alvin-cora alvin-gatekeeper-war "
#ARCHIVED="alvin-indexmessenger "
ALVIN_VALIDATION="alvin-cora-fitnesse "
ALVIN_DEV_CONTAINER="alvin-docker-postgresql "
#ARCHIVED="alvin-cora-docker-fedora alvin-cora-docker-postgresql alvin-docker-index "
ALVIN_CONTAINER="alvin-docker-cora alvin-docker-gatekeeper alvin-cora-docker-fitnesse "
ALL_ALVIN=$ALVIN0" "$ALVIN_DEPLOYMENT" "$ALVIN_VALIDATION

#PARENT, COMMON, CORA, CORE, STORAGE
DIVA0="diva-metadata "
#ARCHIVED="diva-mixedstorage 
DIVA_DEPLOYMENT="diva-cora diva-gatekeeper-war "
#ARCHIVED="diva-indexmessenger "
DIVA_VALIDATION="diva-cora-fitnesse "
#ARCHIVED="DIVA_DEV_CONTAINER0="diva-cora-docker-fedora diva-docker-mock-classic-postgresql "
#ARCHIVED="DIVA_DEV_CONTAINER1="diva-cora-docker-postgresql diva-cora-docker-fcrepo-postgresql "
DIVA_DEV_CONTAINER1="diva-docker-postgresql "
#ARCHIVED="diva-docker-classicfedorasynchronizer "
DIVA_CONTAINER="diva-cora-docker-fitnesse diva-docker-cora diva-docker-gatekeeper "
#ARCHIVED="diva-docker-index 
DIVA_DEV_CONTAINER=$DIVA_DEV_CONTAINER1
ALL_DIVA=$DIVA0" "$DIVA_DEPLOYMENT" "$DIVA_VALIDATION


ALL_JAVA=$PARENT0" "$ALL_COMMON" "$ALL_CORA" "$ALL_CORE" "$ALL_LOGIN" "$ALL_GATEKEEPER" "
ALL_JAVA+=$ALL_CLIENT" "$ALL_STORAGE" "$ALL_BINARYCONVERTER" "$ALL_SEARCH" "$ALL_INDEX" "$ALL_VALIDATION" "
ALL_JAVA+=$INDEX_DEPLOYMENT" "$LOGIN_DEPLOYMENT" "$GATEKEEPER_DEPLOYMENT" "
ALL_JAVA+=$ALL_SYSTEMONE" "$ALL_ALVIN" "$ALL_DIVA

DEV_CONTAINER=$COMMON_PURE_CONTAINER" "$INDEX_CONTAINER" "$BINARYCONVERTER_CONTAINER" "
DEV_CONTAINER+=$SYSTEMONE_DEV_CONTAINER" "$ALVIN_DEV_CONTAINER" "$DIVA_DEV_CONTAINER

SERVER_CONTAINER=$LOGIN_CONTAINER" "$SYSTEMONE_CONTAINER" "$ALVIN_CONTAINER" "$DIVA_CONTAINER

OTHER="friday-monitoring cora-utils cora-jenkins "
#ARCHIVED="cora-indexloader

ALL=$ECLIPSE" "$ALL_JAVA" "$ALL_JS" "$DEV_CONTAINER" "$SERVER_CONTAINER" "$OTHER
