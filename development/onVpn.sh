#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202303forcora2

docker network create tempvpn

docker network connect tempvpn eclipse202303forcora2