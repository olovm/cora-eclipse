#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202009forcora1

docker network create tempvpn

docker network connect tempvpn eclipse202009forcora1