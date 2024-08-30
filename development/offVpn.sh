#! /bin/bash

docker network disconnect tempvpn eclipse202406forcora

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202406forcora
