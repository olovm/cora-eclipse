#! /bin/bash

git clone https://github.com/olovm/cora-eclipse.git ~/workspace/cora-eclipse

chmod +x ~/workspace/cora-eclipse/docker/setupProjects.sh

~/workspace/cora-eclipse/docker/setupProjects.sh

SWT_GTK3=0  ~/eclipse-installer/eclipse-inst