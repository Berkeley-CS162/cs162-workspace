#!/bin/bash

pushd /install_scripts/squish
  make
  cp squish-pty squish-unix setitimer-helper $HOME/.bin
  make clean
popd