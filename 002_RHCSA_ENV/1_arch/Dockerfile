FROM archlinux:latest
ENV container=podman

RUN pacman -Syu --noconfirm
RUN pacman -Sy --noconfirm systemd firewalld openssh sudo procps \
    vim curl less tar gzip iproute2 iputils

RUN mkdir -p /run/sshd

ARG UN="arch-user"
ARG PS="asdf123"

RUN useradd -m -s /bin/bash ${UN}
RUN echo "${UN}:${PS}" | chpasswd 
    # usermod -aG wheel ${UN}

COPY ./config/motd /etc/motd
COPY ./config/sshd_config /etc/ssh/sshd_config

COPY ./scripts/ /scripts
RUN chmod -R +x /scripts

EXPOSE 22

# CMD [ "sleep","3600" ]
CMD [ "/usr/lib/systemd/systemd" ]
