#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202309forcora2

docker network create tempvpn

docker network connect tempvpn eclipse202309forcora2