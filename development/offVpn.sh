#! /bin/bash

docker network disconnect tempvpn eclipse202206forcora1

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202206forcora1
