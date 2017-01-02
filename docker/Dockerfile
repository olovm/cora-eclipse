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

RUN wget https://github.com/olovm/cora-eclipse/raw/master/docker/entrypoint.sh -P /home/$user/
RUN chmod a+x /home/$user/entrypoint.sh
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
CMD /home/$user/eclipse/eclipse
