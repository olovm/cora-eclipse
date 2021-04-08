#! /bin/bash

docker network disconnect tempvpn eclipse202012forcora4

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202012forcora4
