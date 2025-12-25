FROM archlinux:latest

ENV container=podman

RUN pacman -Syu --noconfirm 
RUN pacman -Sy --noconfirm \
    systemd firewalld openssh sudo \
    vim curl less tar gzip iproute2 iputils 

RUN mkdir -p /run/sshd 
      
ARG UN=arch-user
ARG PW=asdf123

RUN useradd -m -s /bin/bash ${UN} && \
    echo "${UN}:${PW}" | chpasswd && \
    usermod -aG wheel ${UN}

COPY ./config/motd /etc/motd
COPY ./config/sshd_config /etc/ssh/ssh_config

RUN mkdir /scripts
COPY ./scripts/ /scripts
RUN chmod +x -R /scripts

EXPOSE 22

CMD [ "/usr/lib/systemd/systemd" ]
