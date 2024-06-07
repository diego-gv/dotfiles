ARG UBUNTU_VERSION=22.04

FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get --no-install-recommends -y install \
    sudo \
    build-essential \
    software-properties-common \
    && apt-get update \
    && apt-get --no-install-recommends -y install apt-utils git rsync gpg-agent snapd \
    && rm -rf /var/lib/apt/lists/*

RUN echo "Set disable_coredump false" >> /etc/sudo.conf

RUN adduser --disabled-password --gecos '' test && adduser test sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER test

COPY --chown=test:test . /home/test/dotfiles

ENV USER test
ENV HOSTNAME docker

ENV PATH="/home/test/bin:${PATH}"

WORKDIR /home/test/dotfiles
