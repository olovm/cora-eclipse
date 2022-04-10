#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202203forcora2

docker network create tempvpn

docker network connect tempvpn eclipse202203forcora2