FROM fedora:25

RUN dnf clean all && \
  dnf install -y \
  wget \
  lsof \
  tar \
  less \
  java-1.8.0-openjdk* \
  maven \
  git \ 
  node \
  npm && \
  dnf clean all
 
ARG user

RUN useradd -d "/home/$user" -u 1000 -m -s /bin/bash $user

RUN wget -O - http://ftp.acc.umu.se/mirror/eclipse.org/oomph/epp/oxygen/R/eclipse-inst-linux64.tar.gz | tar zxf - -C /home/$user

COPY ./entrypoint.sh /home/$user/
RUN chmod a+x /home/$user/entrypoint.sh

RUN chown $user:$user /home/$user -R


RUN wget -O - http://apache.mirrors.spacedump.net/tomcat/tomcat-8/v8.5.16/bin/apache-tomcat-8.5.16.tar.gz  | tar zxf - -C /opt/
RUN wget -O - http://apache.mirrors.spacedump.net/lucene/solr/6.6.0/solr-6.6.0.tgz   | tar zxf - -C /opt/
RUN chown $user:$user /opt/ -R

RUN npm install -g karma-cli

USER $user

#RUN export SWT_GTK3=0
 
#CMD SWT_GTK3=0 /home/$user/eclipse/eclipse
#CMD  /home/$user/eclipse/eclipse
CMD  /home/$user/entrypoint.sh



#built by: 
#docker build --build-arg user=olov -t eclipseforcora3 .

#run with: 
#docker run -ti --privileged -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix 
#-v /mnt/depot/eclipseForCora/workspace:/home/olov/workspace 
#-v /mnt/depot/eclipseForCora/eclipse:/home/olov/eclipse 
#-v /mnt/depot/eclipseP2:/home/olov/.p2 
#-v /mnt/depot/eclipseForCora/m2:/home/olov/.m2 --env user=olov -p 8080:8080 -p 9876:9876 
#--name eclipseForCora1 eclipseforcora1 bash

