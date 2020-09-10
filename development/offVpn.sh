#! /bin/bash

docker network disconnect tempvpn eclipse202006forcora4

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202006forcora4
