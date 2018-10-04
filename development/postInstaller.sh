#! /bin/bash

echo "Running postInstaller..."

workspaceDir=$1
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)
USER=$(id -u -n)

start(){
	changeUserInContexts
}

changeUserInContexts(){
	find /home/$USER/workspace/cora-eclipse/oomph/Servers/ -type f -exec sed -i -e 's/olov/'"$USER"'/g' {} \;
}


# ################# calls start here #######################################
if [ ! $workspaceDir ]; then
  	echo "You must specify the workspace directory.."
else
	start
fi
