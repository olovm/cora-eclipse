FROM fedora:32
# Set a useful default locale
RUN echo "export LANG=en_US.UTF-8" > /opt/export_LANG.sh
RUN echo "export LANGUAGE=en_US.UTF-8" >> /opt/export_LANG.sh
RUN echo "export LC_ALL=en_US.UTF-8" >> /opt/export_LANG.sh
ENV BASH_ENV=/opt/export_LANG.sh \
    ENV=/opt/export_LANG.sh \
    PROMPT_COMMAND="source /opt/export_LANG.sh"
    
# Set the locale
#ENV LANG en_US.UTF-8
#ENV LC_ALL en_US.UTF-8
#ENV LC_CTYPE en_US.UTF-8
#ENV LANGUAGE en_US.UTF-8
#RUN localedef -f UTF-8 -i en_US en_US.UTF-8
#RUN localedef --verbose --force -i en_US -f en_US.UTF-8
#RUN locale
#RUN localedef -v -c -i en_US -f en_US.UTF-8 || true

ARG user
ARG userid
ARG dockergroupid

RUN groupadd -r docker -g$dockergroupid && useradd -d "/home/$user" -u $userid -U -G docker -m -s /bin/bash $user

RUN dnf clean all && \
  dnf install \
  glibc-langpack-en \
  google-noto-sans-runic* \
  google-noto-sans-math-fonts \
  google-noto-sans-arabic* \
  firefox \
  webkit2gtk3 \
  wget \
  telnet \
  nano \
  lsof \
  tar \
  less \
  htop \
  docker \
  java-latest-openjdk java-latest-openjdk-devel \ 
  java-latest-openjdk-javadoc java-latest-openjdk-javadoc-zip \
  java-latest-openjdk-src \
  postgresql \
  maven \
  git \ 
  node \
  npm -y && \
  dnf clean all
  
RUN wget -O - https://ftp.acc.umu.se/mirror/eclipse.org/oomph/epp/2020-09/R/eclipse-inst-linux64.tar.gz | tar zxf - -C /home/$user

COPY ./entrypoint.sh /home/$user/
RUN chmod a+x /home/$user/entrypoint.sh

RUN touch /home/$user/.gitconfig

RUN chown $user:$user /home/$user -R

RUN wget -O - http://apache.mirrors.spacedump.net/tomcat/tomcat-9/v9.0.38/bin/apache-tomcat-9.0.38.tar.gz  | tar zxf - -C /opt/
RUN chown $user:$user /opt/ -R

RUN npm install -g karma-cli

USER $user

CMD  /home/$user/entrypoint.sh
