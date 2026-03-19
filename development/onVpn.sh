#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202603forcora1

docker network create tempvpn

docker network connect tempvpn eclipse202603forcora1