ARG UBUNTU_VERS=bionic

FROM ubuntu:${UBUNTU_VERS}

ARG UBUNTU_VERS=bionic
RUN echo Ubuntu version: ${UBUNTU_VERS}

RUN apt update && apt install -y gnupg ca-certificates && \
   echo "deb https://packages.inverse.ca/SOGo/nightly/4/ubuntu/ ${UBUNTU_VERS} ${UBUNTU_VERS}" >> /etc/apt/sources.list.d/SOGo.list && \
   apt-key adv --keyserver keys.gnupg.net --recv-key 0x810273C4 && \
   mkdir -p /usr/share/doc/sogo && \
   touch /usr/share/doc/sogo/empty.sh && \
   apt update && DEBIAN_FRONTEND=noninteractive apt install -y sogo && \
   ln -s /etc/sogo /config

VOLUME [ "/config" ]