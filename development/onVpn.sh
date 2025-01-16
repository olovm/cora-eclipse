#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202412forcora3

docker network create tempvpn

docker network connect tempvpn eclipse202412forcora3