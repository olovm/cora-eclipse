#! /bin/bash

docker network disconnect tempvpn eclipse202512forcora1

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202512forcora1
