#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202309forcora1

docker network create tempvpn

docker network connect tempvpn eclipse202309forcora1