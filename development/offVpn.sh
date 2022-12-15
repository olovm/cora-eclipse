#! /bin/bash

docker network disconnect tempvpn eclipse202212forcora2

docker network rm tempvpn

docker network connect eclipseForCoraNet eclipse202212forcora2
