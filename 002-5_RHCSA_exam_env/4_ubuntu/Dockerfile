FROM ubuntu:24.04

ENV contaienr=podman

RUN apt update 
RUN apt install -y --no-install-recommends systemd ufw sudo procps openssh \
    vim curl gzip tar less iproute2 iputils && \
    apt get clean

RUN mkdir -p /run/sshd

ARG UN=ubuntu-user
ARG PW=asdf123

RUN useradd -m -s /bin/bash ${UN} && \
    echo "${UN}:${PW}" | chpasswd && \
    usermod -aG sudo ${UN}

COPY ./config/motd /etc/motd
COPY ./config/sshd_config /etc/ssh/ssh_config

COPY ./scripts/ /scripts
RUN chmod -R +x /scripts 

EXPOSE 22
CMD [ "ls " ]
 

