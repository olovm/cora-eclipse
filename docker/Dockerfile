FROM fedora:28

ARG user
ARG userid
ARG dockergroupid

#RUN useradd -d "/home/$user" -u 1000 -m -s /bin/bash $user
#RUN groupadd -r docker -g$dockergroupid && useradd -d "/home/$user" -u 1000 -U -G docker -m -s /bin/bash $user
RUN groupadd -r docker -g$dockergroupid && useradd -d "/home/$user" -u $userid -U -G docker -m -s /bin/bash $user

RUN dnf clean all && \
  dnf install -y \
  firefox \
  webkit2gtk3 \
  wget \
  lsof \
  tar \
  less \
  docker \
  java-10-openjdk \
  java-11-openjdk \
  maven \
  git \ 
  node \
  npm && \
  dnf clean all

RUN wget -O - https://ftp.acc.umu.se/mirror/eclipse.org/oomph/epp/2018-09/R/eclipse-inst-linux64.tar.gz | tar zxf - -C /home/$user

COPY ./entrypoint.sh /home/$user/
RUN chmod a+x /home/$user/entrypoint.sh

RUN chown $user:$user /home/$user -R

RUN wget -O - http://apache.mirrors.spacedump.net/tomcat/tomcat-9/v9.0.12/bin/apache-tomcat-9.0.12.tar.gz  | tar zxf - -C /opt/
RUN chown $user:$user /opt/ -R

RUN npm install -g karma-cli

USER $user

CMD  /home/$user/entrypoint.sh
