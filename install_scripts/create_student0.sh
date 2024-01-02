#!/bin/bash

set -e

HOME=/home/workspace

pushd $HOME
  mkdir -p code/personal
  pushd ./code/personal
    git init
    git remote add staff https://github.com/Berkeley-CS162/student0.git
  popd
popd