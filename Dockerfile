FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/workspace

RUN yes | unminimize

RUN apt-get update \
  && apt-get install -y \
    # ack-grep \
    binutils \
    cgdb \
    clang \
    clang-format \
    cmake \
    curl \
    exuberant-ctags \
    g++ \
    gcc \
    gdb \
    gdb-multiarch \
    git \
    # jupyter \
    libxrandr-dev \
    # libncurses5 \
    libncurses5-dev \
    qemu \
    qemu-system-i386 \
    # texinfo \
    silversearcher-ag \
    tmux \
    vim \
    valgrind \
    autoconf \
    wget \
    python3 \
    python3-pip \
    python-is-python3 \
    libjson-c-dev \
    libfuse-dev \
    sudo \
    # glibc-doc \
    # libx32gcc-10-dev-i386-cross \
    # libc6-dev-i386-cross \
    # libtiff5-dev \
    # libjpeg8-dev \
    # libopenjp2-7-dev \
    # zlib1g-dev \
    # libfreetype6-dev \
    # liblcms2-dev \
    # libwebp-dev \
    # tcl8.6-dev \
    # tk8.6-dev \
    # python3-tk \
    # libharfbuzz-dev \
    # libfribidi-dev \
    # libxcb1-dev \
    fzf \
    openssh-server \
    man \
    file \
    gcc-i686-linux-gnu \
    qemu-user \
    rsync \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --home-dir /home/workspace --user-group workspace
RUN echo workspace:workspace | chpasswd
RUN chsh -s /bin/bash workspace
RUN echo "workspace ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /home/workspace
COPY ./home/. ./

COPY ./install_scripts/. /install_scripts
WORKDIR /install_scripts
RUN ./create_group0.sh
RUN ./create_student0.sh
RUN ./install_bochs.sh
RUN ./install_rust.sh
# RUN ./install_fzf.sh
RUN ./squish/install.sh

WORKDIR /
COPY entrypoint.sh .
COPY ./bin/. ./bin

RUN git config --global init.defaultBranch main

RUN find /home/workspace/. -not -type d -not -path "./code/*" -not -name ".version" -print0 | LC_ALL=C sort -z | xargs -0 sha256sum | sha256sum > /home/workspace/.version

RUN chown -R workspace:workspace /home/workspace

RUN mv /home/workspace /workspace

USER workspace

ENTRYPOINT [ "/entrypoint.sh" ]