#! /bin/bash

docker network disconnect tempvpn eclipse202412forcora3

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202412forcora3
