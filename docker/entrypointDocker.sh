#! /bin/bash
# from: http://vitorbaptista.com/how-to-access-hosts-docker-socket-without-root
# Based on https://github.com/jenkinsci/docker/issues/196#issuecomment-179486312

# This only works if the docker group does not already exist

echo "in entrypointDocker.sh"

DOCKER_SOCKET=/var/run/docker.sock
DOCKER_GROUP=docker
REGULAR_USER=olov

if [ -S ${DOCKER_SOCKET} ]; then
    echo "createing group docker"
    DOCKER_GID=$(stat -c '%g' ${DOCKER_SOCKET})
    groupadd -for -g ${DOCKER_GID} ${DOCKER_GROUP}
    usermod -aG ${DOCKER_GROUP} ${REGULAR_USER}
fi

# Change to regular user and run the rest of the entry point
#su ${REGULAR_USER} -c "/usr/bin/env bash entrypoint.sh ${@}"
su ${REGULAR_USER} -c "/usr/bin/env bash ${@}"