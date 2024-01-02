#!/bin/bash

set -e

HOME=/home/workspace

pushd $HOME
  mkdir -p code/group
  pushd ./code/group
    git init
    git remote add staff https://github.com/Berkeley-CS162/group0.git
  popd
popd