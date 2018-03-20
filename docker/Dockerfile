FROM fedora:27

ARG user
ARG dockergroupid

#RUN useradd -d "/home/$user" -u 1000 -m -s /bin/bash $user
RUN groupadd -r docker -g$dockergroupid && useradd -d "/home/$user" -u 1000 -U -G docker -m -s /bin/bash $user

RUN dnf clean all && \
  dnf install -y \
  wget \
  lsof \
  tar \
  less \
  docker \
  java-1.8.0-openjdk* \
  maven \
  git \ 
  node \
  npm && \
  dnf clean all

RUN wget -O - http://ftp.acc.umu.se/mirror/eclipse.org/oomph/epp/oxygen/R/eclipse-inst-linux64.tar.gz | tar zxf - -C /home/$user

COPY ./entrypoint.sh /home/$user/
RUN chmod a+x /home/$user/entrypoint.sh

#COPY ./entrypointDocker.sh /home/$user/
#RUN chmod a+x /home/$user/entrypointDocker.sh

RUN chown $user:$user /home/$user -R


#RUN wget -O - http://apache.mirrors.spacedump.net/lucene/solr/6.6.2/solr-6.6.2.tgz   | tar zxf - -C /opt/
RUN wget -O - http://apache.mirrors.spacedump.net/tomcat/tomcat-8/v8.5.28/bin/apache-tomcat-8.5.28.tar.gz  | tar zxf - -C /opt/
RUN chown $user:$user /opt/ -R

#RUN cp -r /opt/solr-6.6.2/server/solr /opt/solrCopy

RUN npm install -g karma-cli

USER $user

#RUN export SWT_GTK3=0
 
#CMD SWT_GTK3=0 /home/$user/eclipse/eclipse
#CMD  /home/$user/eclipse/eclipse
CMD  /home/$user/entrypoint.sh
#CMD  /home/$user/entrypointDocker.sh

