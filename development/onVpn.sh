#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202103forcora2

docker network create tempvpn

docker network connect tempvpn eclipse202103forcora2