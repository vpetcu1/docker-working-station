FROM ubuntu:20.04
MAINTAINER Vasilica Petcu <vpetcu1@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

ARG GRAAL_VERSION=1.0.0-rc16

USER root

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

#prepare & install x2go
RUN apt-get update -y -qq && \
    apt-get dist-upgrade -y && \
    apt-get install locales software-properties-common -y && \
    locale-gen en_US.UTF-8 && \

# install supervisor and openssh
    apt-get install -y supervisor openssh-server

# add x2go repositoires
RUN add-apt-repository ppa:x2go/stable && apt-get update -y -qq

# install x2go with mate bingings
RUN apt-get install -y x2goserver x2goserver-xsession x2gomatebindings

#install Global Menu & plank & wallpapers
RUN apt-get install -y mate-applet-appmenu
    
# install terminal
RUN apt-get install -y mate-terminal
#install theme
RUN apt-get install -y numix-blue-gtk-theme numix-icon-theme 
#install zip 
RUN apt-get install -y zip unzip
#install docking panel
RUN apt-get install -y plank
#install ping
RUN apt-get install -y iputils-ping
#install telnet
RUN apt-get install -y telnet
#install docking firefox
RUN apt-get install -y firefox
#install docking chromium-browser
RUN apt-get install -y chromium-browser
#install docking mate-control-center
RUN apt-get install -y mate-control-center
#install docking pluma
RUN apt-get install -y pluma
#install docking dmz-cursor-theme
RUN apt-get install -y dmz-cursor-theme
#install mate-system-monitor
RUN apt-get install mate-system-monitor -y

#install mate-tweak
RUN apt-get install mate-tweak -y

# sshd stuff
RUN mkdir -p /var/run/sshd && \
    sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && \
    sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && \
    sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
    sed -i "s/#PasswordAuthentication/PasswordAuthentication/g" /etc/ssh/sshd_config && \

# fix so resolvconf can be configured
   echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections && \

# create needed folders
    mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix && \
    mkdir -p /var/run/dbus


#clean up
RUN rm -rf /tmp/*
RUN apt-get remove -y apport && apt autoremove -y
RUN apt-get autoclean && apt-get autoremove
RUN rm -rf /var/lib/apt/lists/*


ENV REMOTE_USER=desktop
ENV PROJECT_NAME=Test
ENV REMOTE_PASSWORD=password

#copy necessary to configure workingstation
COPY ["*.conf", "/etc/supervisor/conf.d/"]
COPY ["*.sh", "/"]
COPY ["home.zip", "/home.zip"]

RUN chmod +x /*.sh

RUN sh /x2go-mate-base-entrypoint.sh
EXPOSE 22
ENTRYPOINT ["/start-supervisor.sh"]
