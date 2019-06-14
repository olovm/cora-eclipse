FROM fedora:29

# Set the locale
ENV LANG en_US.UTF-8
ENV LC_CTYPE en_US.utf8

ARG user
ARG userid
ARG dockergroupid
ARG eclipsebranch

RUN groupadd -r docker -g$dockergroupid && useradd -d "/home/$user" -u $userid -U -G docker -m -s /bin/bash $user

RUN dnf clean all && \
  dnf install -y \
  firefox \
  webkit2gtk3 \
  wget \
  lsof \
  tar \
  less \
  htop \
  docker \
  java-11-openjdk java-11-openjdk-devel java-11-openjdk-javadoc \
  maven \
  git \ 
  node \
  npm && \
  dnf clean all

RUN wget -O - https://ftp.acc.umu.se/mirror/eclipse.org/oomph/epp/2019-03/R/eclipse-inst-linux64.tar.gz | tar zxf - -C /home/$user

COPY ./entrypoint.sh /home/$user/
RUN chmod a+x /home/$user/entrypoint.sh

RUN touch /home/$user/.gitconfig

RUN chown $user:$user /home/$user -R

RUN wget -O - http://apache.mirrors.spacedump.net/tomcat/tomcat-9/v9.0.17/bin/apache-tomcat-9.0.17.tar.gz  | tar zxf - -C /opt/
RUN chown $user:$user /opt/ -R

RUN npm install -g karma-cli

USER $user

CMD  /home/$user/entrypoint.sh eclipsebranch
