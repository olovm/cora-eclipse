#! /bin/bash

docker network disconnect tempvpn eclipse202409forcora1

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202409forcora1
