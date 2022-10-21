#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202209forcora3

docker network create tempvpn

docker network connect tempvpn eclipse202209forcora3