#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202006forcora4

docker network create tempvpn

docker network connect tempvpn eclipse202006forcora4