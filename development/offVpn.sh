#! /bin/bash

docker network disconnect tempvpn eclipse202509forcora1

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202509forcora1
