#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202012forcora1

docker network create tempvpn

docker network connect tempvpn eclipse202012forcora1