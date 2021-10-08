#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202109forcora2

docker network create tempvpn

docker network connect tempvpn eclipse202109forcora2