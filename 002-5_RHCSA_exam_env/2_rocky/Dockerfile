FROM rockylinux:9
ENV contaier=podman

RUN dnf install -y --allowerasing systemd firewalld openssh-server procps-ng sudo \
    vim curl less gzip tar iproute iputils && \
    dnf clean all

RUN mkdir -p /run/sshd

ARG UN=rocky-user
ARG PW=asdf123

RUN useradd -m -s /bin/bash ${UN} && \
    echo "${UN}:${PW}" | chpasswd && \
    usermod -aG wheel ${UN}

COPY ./config/motd /etc/motd
COPY ./config/sshd_config /env/ssh/sshd_config


RUN mkdir /scripts
COPY ./scripts/init1.sh /scripts/
RUN chmod -R +x /scripts/

EXPOSE 22

CMD [ "/sbin/init" ]









