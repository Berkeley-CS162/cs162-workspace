FROM ubuntu:22.04

# Set timezone (important for some packages) 
ARG TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV HOME=/home/workspace

RUN yes | unminimize

# Install packages (break this up into checkpoints if you're having build issues)
# Apt caching from: https://stackoverflow.com/a/72851168
# TODO: could probably remove some of these packages
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
  --mount=target=/var/cache/apt,type=cache,sharing=locked \
  rm -f /etc/apt/apt.conf.d/docker-clean \
  &&  apt-get update \
  && apt-get install -y \
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
  libxrandr-dev \
  libncurses5-dev \
  qemu \
  qemu-system-i386 \
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
  fzf \
  openssh-server \
  man \
  file \
  gcc-i686-linux-gnu \
  qemu-user \
  rsync \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --home-dir /home/workspace --user-group workspace && echo workspace:workspace | chpasswd \
  && chsh -s /bin/bash workspace && echo "workspace ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /home/workspace
COPY ./home/. ./

COPY ./install_scripts/. /install_scripts
WORKDIR /install_scripts
RUN ./create_group0.sh && ./create_student0.sh && ./install_bochs.sh && ./install_rust.sh && ./squish/install.sh

WORKDIR /
COPY entrypoint.sh .
COPY ./bin/. ./bin

RUN git config --global init.defaultBranch main

RUN find /home/workspace/. -not -type d -not -path "./code/*" -not -name ".version" -print0 | LC_ALL=C sort -z | xargs -0 sha256sum | sha256sum > /home/workspace/.version

RUN chown -R workspace:workspace /home/workspace

RUN mv /home/workspace /workspace

USER workspace

ENTRYPOINT [ "/entrypoint.sh" ]