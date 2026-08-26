ARG UBUNTU_VERSION=25.04

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
    chmod 0440 /etc/sudoers.d/garvi && \
    chown -R garvi:garvi /home/garvi

USER garvi:garvi
WORKDIR /home/garvi

CMD ["/bin/bash"]
