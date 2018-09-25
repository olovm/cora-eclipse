#! /bin/bash

echo "Running postInstaller..."

workspaceDir=$1
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)

start(){
	echo "NOT YET DOING ANYTHING USEFUL"
}


# ################# calls start here #######################################
if [ ! $workspaceDir ]; then
  	echo "You must specify the workspace directory.."
else
	start
fi
