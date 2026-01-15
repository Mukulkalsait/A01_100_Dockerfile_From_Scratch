FROM registry.access.redhat.com/ubi10/ubi-init
ENV container=podman

STOPSIGNAL SIGRTMIN+3

RUN dnf clean all

RUN dnf install -y --allowerasing systemd openssh-server openshh-client sudo procps \
    vim less curl wget iproute iputils gzip tar passwd

RUN dnf clean all

RUN mkdir -p /run/sshd


ARG UN="ubi-user"
ARG PS="asdf123"

RUN useradd -m -s /bin/bash ${UN}
RUN echo "${UN}:${PS}" | chpasswd && \
    usermod -aG wheel ${UN}


COPY ./config/motd /etc/motd
COPY ./config/sshd_config /etc/ssh/sshd_config

COPY ./scripts/init.sh /scripts
RUN chmod -R +x /scripts

EXPOSE 22

CMD [ "/usr/sbin/init" ]
