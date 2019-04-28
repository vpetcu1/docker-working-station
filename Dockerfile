FROM ubuntu:18.04
MAINTAINER Josh Lukens <jlukens@botch.com>
ENV DEBIAN_FRONTEND noninteractive

ARG GRAAL_VERSION=1.0.0-rc16

USER root

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update -y -qq && \
    apt-get dist-upgrade -y && \
    apt-get install locales software-properties-common -y && \
    locale-gen en_US.UTF-8 && \

# add x2go repositoires
    add-apt-repository ppa:x2go/stable && \
    apt-get update -y -qq && \

# install supervisor and openssh
    apt-get install -y supervisor openssh-server pwgen vim && \

# install x2go and Mate
    apt-get install -y x2goserver x2goserver-xsession && \
    apt-get install -y ubuntu-mate-desktop x2gomatebindings && \

# clean up
    apt-get autoclean && apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && \

# sshd stuff
    mkdir -p /var/run/sshd && \
    sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && \
    sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && \
    sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
    sed -i "s/#PasswordAuthentication/PasswordAuthentication/g" /etc/ssh/sshd_config && \

# fix so resolvconf can be configured
   echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections && \

# create needed folders
    mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix && \
    mkdir -p /var/run/dbus

# install tightvncserver
RUN apt-get update && apt-get install tightvncserver -y

# install openJDK
RUN apt-get install default-jdk -y

# install maven
RUN wget https://www-us.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz -P /tmp
RUN tar xf /tmp/apache-maven-*.tar.gz -C /opt
RUN ln -s /opt/apache-maven-3.6.0 /opt/maven


#install graalvm
RUN wget https://github.com/oracle/graal/releases/download/vm-$GRAAL_VERSION/graalvm-ce-$GRAAL_VERSION-linux-amd64.tar.gz -P /tmp
RUN tar xf /tmp/graalvm-ce-*.tar.gz -C /opt
RUN ln -s /opt/graalvm-ce-1.0.0-rc16 /opt/graalvm

#install docker
RUN apt-get update
RUN apt-get -y install apt-transport-https ca-certificates curl software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo \"$UBUNTU_CODENAME\") stable"
RUN apt-get update
RUN apt-get -y install docker-ce docker-compose


# install eclipse
RUN wget http://ftp.halifax.rwth-aachen.de/eclipse//technology/epp/downloads/release/2019-03/R/eclipse-jee-2019-03-R-linux-gtk-x86_64.tar.gz -P /tmp
RUN tar xf /tmp/eclipse-jee-*.tar.gz -C /opt

#install git
RUN apt-get update
RUN apt-get install git -y

#clean stuff
RUN rm -rf /tmp/*
RUN apt-get remove -y apport 

#copy necessary to configure workingstation
COPY ["*.conf", "/etc/supervisor/conf.d/"]
COPY ["*.sh", "/"]

RUN cp /env.sh /etc/profile.d/env.sh
RUN chmod +x /*.sh

EXPOSE 22
ENV USER=vpetcu
ENTRYPOINT ["/docker-entrypoint.sh"]