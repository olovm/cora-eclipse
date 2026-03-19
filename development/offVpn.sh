#! /bin/bash

docker network disconnect tempvpn eclipse202603forcora1

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202603forcora1
