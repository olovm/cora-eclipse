#! /bin/bash

echo "Running postInstaller..."

workspaceDir=$1
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)
USER=$(id -u -n)

start(){
	changeUserInContexts
	linkJsClientToTomcats
}

changeUserInContexts(){
	find /home/$USER/workspace/cora-eclipse/oomph/Servers/ -type f -exec sed -i -e 's/olov/'"$USER"'/g' {} \;
}

linkJsClientToTomcats(){
	mkdir -p /home/$USER/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/webapps
	mkdir -p /home/$USER/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp1/webapps
	mkdir -p /home/$USER/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp2/webapps
	ln -s /home/$USER/workspace/cora-jsclient/src/main/webapp/ /home/$USER/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/webapps/jsclient
	ln -s /home/$USER/workspace/cora-jsclient/src/main/webapp/ /home/$USER/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp1/webapps/jsclient
	ln -s /home/$USER/workspace/cora-jsclient/src/main/webapp/ /home/$USER/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp2/webapps/jsclient
}

# ################# calls start here #######################################
if [ ! $workspaceDir ]; then
  	echo "You must specify the workspace directory.."
else
	start
fi
