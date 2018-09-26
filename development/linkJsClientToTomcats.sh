#! /bin/bash

echo "Running linkJsClientToTomcats..."

workspaceDir=$1
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)
USER=$(id -u -n)

start(){
	linkJsClientToTomcats
}


linkJsClientToTomcats(){
#	mkdir -p /home/$USER/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/webapps
#	mkdir -p /home/$USER/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp1/webapps
#	mkdir -p /home/$USER/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp2/webapps
	ln -s /home/$USER/workspace/cora-jsclient/src/main/webapp/ /home/$USER/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/webapps/jsclient
	ln -s /home/$USER/workspace/cora-jsclient/src/main/webapp/ /home/$USER/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp1/webapps/jsclient
	ln -s /home/$USER/workspace/cora-jsclient/src/main/webapp/ /home/$USER/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp2/webapps/jsclient
}

# ################# calls start here #######################################
start
