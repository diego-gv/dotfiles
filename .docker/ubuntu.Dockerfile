ARG UBUNTU_VERSION=24.04

FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    cmake \
    make \
    shellcheck \
    software-properties-common \
    sudo \
    wget && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash garvi && \
    echo "garvi ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/garvi && \
    chmod 0440 /etc/sudoers.d/garvi

USER garvi:garvi
COPY --chown=garvi . /home/garvi/.dotfiles
WORKDIR /home/garvi/.dotfiles

CMD ["/bin/bash"]
