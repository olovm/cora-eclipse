#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202012forcora2

docker network create tempvpn

docker network connect tempvpn eclipse202012forcora2