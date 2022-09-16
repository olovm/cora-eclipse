#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202209forcora1

docker network create tempvpn

docker network connect tempvpn eclipse202209forcora1