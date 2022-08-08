#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202206forcora1

docker network create tempvpn

docker network connect tempvpn eclipse202206forcora1