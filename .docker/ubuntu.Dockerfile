ARG UBUNTU_VERSION=24.04

FROM ubuntu:${UBUNTU_VERSION}

RUN apt-get -y update
RUN apt-get install -y make cmake sudo software-properties-common apt-transport-https wget

RUN useradd -ms /bin/bash garvi && \
    echo "garvi ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/garvi && \
    chmod 0440 /etc/sudoers.d/garvi

USER garvi:garvi
COPY --chown=garvi . /home/garvi/.dotfiles
WORKDIR /home/garvi/.dotfiles

CMD ["/bin/bash"]
