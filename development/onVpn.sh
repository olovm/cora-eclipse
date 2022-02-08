#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202112forcora2

docker network create tempvpn

docker network connect tempvpn eclipse202112forcora2