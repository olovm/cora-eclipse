FROM fedora:25

RUN dnf install -y \
  wget \
  tar \
  less \
  java-1.8.0-openjdk* \
  maven \
  git
 
ARG user

RUN useradd -d "/home/$user" -u 1000 -m -s /bin/bash $user

#RUN echo 'user set to: ' 
#RUN echo $user
#RUN useradd $user

#RUN mkdir /home/$user/ -p
#COPY ./installEclipse.sh /home/$user/installEclipse.sh
#RUN chmod a+x /home/$user/installEclipse.sh
#RUN /home/$user/installEclipse.sh
#COPY /eclipse /home/$user/eclipse/
#RUN chown $user:$user /home/$user -R

RUN wget -O - http://saimei.acc.umu.se/mirror/eclipse.org/oomph/epp/neon/R2a/eclipse-inst-linux64.tar.gz | tar zxf - -C /home/$user

#RUN wget https://github.com/olovm/cora-eclipse/raw/master/docker/entrypoint.sh -P /home/$user/
COPY ./entrypoint.sh /home/$user/
RUN chmod a+x /home/$user/entrypoint.sh

RUN wget -O - http://apache.mirrors.spacedump.net/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz  | tar zxf - -C /home/$user

RUN chown $user:$user /home/$user -R


#git clone https://github.com/olovm/cora-eclipse.git /home/$user/workspace/cora-eclipse
#RUN git clone https://github.com/olovm/cora-eclipse.git /home/$user/workspace/cora-eclipse

#COPY ./setupEclipse.sh /home/$user/
#RUN chown $user:$user /home/$user/setupEclipse.sh
#RUN chmod a+x /home/$user/setupEclipse.sh

#COPY ./setupProjects.sh /home/$user/
#RUN chown $user:$user /home/$user/setupProjects.sh
#RUN chmod a+x /home/$user/setupProjects.sh


USER $user
#USER olov

#USER newuser
#WORKDIR /home/$user
#export USER="$(id -un)"
#export USER=$user

#RUN /home/$user/setupEclipse.sh

#RUN sed -i '1i -pluginCustomization' /home/$user/eclipse/eclipse.ini 
#RUN sed -i '2i /home/'$user'/eclipse/plugin_customization.ini' /home/$user/eclipse/eclipse.ini
#COPY ./plugin_customization.ini /home/$user/eclipse/plugin_customization.ini

#RUN mkdir /home/$user/workspace
#RUN /home/$user/setupProjects.sh


#COPY ./init.sh /
#RUN chmod a+x init.sh
#CMD [ "/init.sh" ]
CMD SWT_GTK3=0 /home/$user/eclipse/eclipse

#built by: docker build --build-arg user=olov -t fedora25test .
#run with: docker run -ti     --privileged     -e DISPLAY=$DISPLAY       
# -v /tmp/.X11-unix:/tmp/.X11-unix 
#-v /mnt/depot/eclipseForCora/workspace:/home/olov/workspace 
#-v /mnt/depot/eclipseForCora/eclipse:/home/olov/eclipse 
#-v /mnt/depot/eclipseP2:/home/olov/eclipsep2 
#--env user=olov    fedora25test bash