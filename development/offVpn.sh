#! /bin/bash

docker network disconnect tempvpn eclipse202112forcora2

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202112forcora2
