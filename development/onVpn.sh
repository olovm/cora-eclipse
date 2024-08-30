#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202406forcora

docker network create tempvpn

docker network connect tempvpn eclipse202406forcora