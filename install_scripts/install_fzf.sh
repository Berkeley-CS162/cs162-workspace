#!/bin/bash

set -e

VERSION=0.25.0

pushd /install_scripts
  git clone https://github.com/junegunn/fzf.git -b $VERSION
  pushd /install_scripts/fzf
    ./install --bin --no-update-rc --no-completion --key-bindings
    cp -r bin/. $HOME/.bin/
  popd
  rm -rf /install_scripts/fzf
popd