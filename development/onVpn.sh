#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202409forcora2

docker network create tempvpn

docker network connect tempvpn eclipse202409forcora2