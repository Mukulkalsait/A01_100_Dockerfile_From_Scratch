FROM jenkins/jenkins:lts

USER root

RUN apt-get update
RUN apt-get install -y --no-install-recommends podman uidmap fuse-overlayfs slirp4netns && rm -rf /var/lib/apt/lists/* 
# Make newuidmap/newgidmap work better in some nested scenarios
RUN chmod u+s /usr/bin/newuidmap /usr/bin/newgidmap || true

USER jenkins
