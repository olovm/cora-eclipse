#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202106forcora3

docker network create tempvpn

docker network connect tempvpn eclipse202106forcora3