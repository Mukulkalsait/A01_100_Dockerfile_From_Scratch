FROM registry.access.redhat.com/ubi9/ubi-init

ENV container=podman

RUN dnf clean all  
RUN dnf install -y --allowerasing systemd openssh-server sudo procps-ng \
    vim curl less gzip tar iproute iputils && \
    dnf clean all

RUN mkdir -p /run/sshd

ARG UN=ubi-user
ARG PS=asdf123

RUN useradd -m -s /bin/bash ${UN} && \ 
    echo "${UN}:${PS}" | chpasswd && \ 
    usermod -aG wheel ${UN}

COPY ./config/motd /etc/motd
COPY ./config/sshd_config /etc/ssh/ssh_config

COPY ./scripts/ /scripts
RUN chmod +x -R /scripts

CMD [ "/sbin/init" ]


