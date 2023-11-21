#! /bin/bash

docker network disconnect tempvpn eclipse202309forcora1

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202309forcora1
