FROM fedora:26

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
  npm \
  postgresql \
  postgresql-server \
  postgresql-contrib && \
  dnf clean all
 
ARG user

#ENV 
#RUN export PGDATA=/var/lib/pgsql/data
#RUN touch /var/lib/pgsql/data/
#RUN systemctl enable postgresql
#RUN postgresql-setup initdb
#RUN postgresql-setup --initdb --unit postgresql2 --new-systemd-unit --datadir=/var/lib/pgsql/data --port 5432
#RUN postgresql-setup --initdb --unit postgresql  --datadir=/var/lib/pgsql/data 
#RUN systemctl start postgresql
#RUN cp -r  /var/lib/pgsql/data /opt/pgsqlCopy


RUN useradd -d "/home/$user" -u 1000 -m -s /bin/bash $user

RUN wget -O - http://ftp.acc.umu.se/mirror/eclipse.org/oomph/epp/oxygen/R/eclipse-inst-linux64.tar.gz | tar zxf - -C /home/$user

COPY ./entrypoint.sh /home/$user/
RUN chmod a+x /home/$user/entrypoint.sh

RUN chown $user:$user /home/$user -R


RUN wget -O - http://apache.mirrors.spacedump.net/tomcat/tomcat-8/v8.5.20/bin/apache-tomcat-8.5.20.tar.gz  | tar zxf - -C /opt/
RUN wget -O - http://apache.mirrors.spacedump.net/lucene/solr/6.6.1/solr-6.6.1.tgz   | tar zxf - -C /opt/
RUN chown $user:$user /opt/ -R

RUN cp -r /opt/solr-6.6.1/server/solr /opt/solrCopy

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

