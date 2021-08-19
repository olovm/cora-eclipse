#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202106forcora2

docker network create tempvpn

docker network connect tempvpn eclipse202106forcora2