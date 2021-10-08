#! /bin/bash

docker network disconnect tempvpn eclipse202109forcora2

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202109forcora2
