#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202412forcora1

docker network create tempvpn

docker network connect tempvpn eclipse202412forcora1