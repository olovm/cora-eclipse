#! /bin/bash

docker network disconnect tempvpn eclipse202103forcora1

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202103forcora1
