#! /bin/bash

docker network disconnect tempvpn eclipse202203forcora1

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202203forcora1
