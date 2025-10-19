#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202509forcora1

docker network create tempvpn

docker network connect tempvpn eclipse202509forcora1