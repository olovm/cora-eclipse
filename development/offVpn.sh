#! /bin/bash

docker network disconnect tempvpn eclipse202503forcora1

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202503forcora1
