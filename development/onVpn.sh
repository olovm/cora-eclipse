#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202606forcora1

docker network create tempvpn

docker network connect tempvpn eclipse202606forcora1