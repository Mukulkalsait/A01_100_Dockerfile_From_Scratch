FROM ubuntu:26.04
ENV container=podman

RUN apt update -y && apt upgrade -y
RUN apt install -y --no-install-recommends systemd firewalld openssh-server sudo procps \
    vim curl wget less iproute2 iputils-ping gzip tar
RUN apt-get clean
RUN mkdir -p /run/sshd

ARG UN="ubuntu-user"
ARG PS="asdf123"

RUN useradd -m -s /bin/bash ${UN}
RUN echo "${UN}:${PS}" | chpasswd && \
    usermod -aG sudo  ${UN}

COPY ./config/motd /etc/motd
COPY ./config/sshd_config /etc/ssh/sshd_config

COPY ./scripts/init.sh /scripts
RUN chmod -R +x /scripts

EXPOSE 22

CMD [ "/usr/lib/systemd/systemd" ]
