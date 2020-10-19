#! /bin/bash

docker network disconnect tempvpn eclipse202009forcora1NoPorts

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202009forcora1NoPorts
