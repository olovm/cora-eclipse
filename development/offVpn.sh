#! /bin/bash

docker network disconnect tempvpn eclipse202412forcora2

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202412forcora2
