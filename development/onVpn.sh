#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202503forcora2

docker network create tempvpn

docker network connect tempvpn eclipse202503forcora2