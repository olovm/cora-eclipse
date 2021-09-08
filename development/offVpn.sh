#! /bin/bash

docker network disconnect tempvpn eclipse202106forcora3

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202106forcora3
