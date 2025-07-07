ARG FEDORA_VERSION=43

FROM fedora:${FEDORA_VERSION}

RUN yum -y update
RUN yum install -y make cmake sudo curl
# wget shadow-utils ncurses git
RUN useradd -ms /bin/bash garvi && \
    echo "garvi ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/garvi && \
    chmod 0440 /etc/sudoers.d/garvi

USER garvi:garvi
COPY --chown=garvi . /home/garvi/.dotfiles
WORKDIR /home/garvi/.dotfiles

CMD ["/bin/bash"]
