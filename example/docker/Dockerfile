# Baseimage for Docker-related Vagrant environments
FROM ubuntu:20.04
MAINTAINER Sergey Arkhipov <nineseconds@yandex.ru>

# Environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

## Do common baseimage actions
#RUN echo "/root" > /etc/container_environment/HOME && \
    #echo "noninteractive" > /etc/container_environment/DEBIAN_FRONTEND && \
    #echo "linux" > /etc/container_environment/TERM && \
    #rm -f /etc/service/sshd/down && \
    #/usr/sbin/enable_insecure_key && \
    #/etc/my_init.d/00_regen_ssh_host_keys.sh

# Install necessary packages
RUN apt-get -qq update && \
    apt-get -qq install -y --no-install-recommends \
        git \
        vim \
        nano \
        curl \
        openssh-server \
        ca-certificates \
        sudo \
        rsync && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add Vagrant user and key, prep sshd to run
RUN useradd vagrant -m && \
    mkdir -p /home/vagrant/.ssh && \
    curl -sL https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub > /home/vagrant/.ssh/authorized_keys && \
    chown -R vagrant: /home/vagrant && \
    echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    mkdir -p /run/sshd

# Cleanups
RUN rm -rf /tmp/* /var/tmp/* /etc/fstab

# Init process is entrypoint
CMD ["/usr/sbin/sshd", "-D"]

