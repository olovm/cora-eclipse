#! /bin/bash

USER=$1

if [ ! $USER ]; then
  	echo you must specify the userName to be used when building eclipseforcoraoxygen
else
	buildEclipseForCora.sh $USER
	setupDirectoriesAndScriptsForEclipseForCora.sh
	../eclipseForCora/startEclipseForCora.sh $USER
fi
