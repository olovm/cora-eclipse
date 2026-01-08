#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202512forcora1

docker network create tempvpn

docker network connect tempvpn eclipse202512forcora1