#! /bin/bash

docker network disconnect eclipseForCoraNet eclipse202603forcora2

docker network create tempvpn

docker network connect tempvpn eclipse202603forcora2