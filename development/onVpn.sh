#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202006forcora3

docker network create tempvpn

docker network connect tempvpn eclipse202006forcora3