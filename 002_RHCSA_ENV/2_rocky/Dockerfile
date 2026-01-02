FROM rockylinux:9.3
ENV container=podman

RUN dnf clean all
RUN dnf install -y --allowerasing systemd firewalld openssh-server sudo procps \
    vim less curl wget gzip tar iputils iproute
RUN dnf clean all

RUN mkdir -p /run/sshd


ARG UN="rocky-user"
ARG PS="asdf123"

RUN useradd -m -s /bin/bash ${UN}
RUN echo "${UN}:${PS}" | chpasswd && \
    usermod -aG wheel ${UN}


COPY ./config/motd /etc/motd
COPY ./config/sshd_config /etc/ssh/sshd_config

COPY ./scripts/init.sh /scripts/
RUN chmod -R +x /scripts

EXPOSE 22

CMD [ "/usr/sbin/init" ]



