#! /bin/bash

docker network disconnect tempvpn eclipse202606forcora1

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202606forcora1
