#!/bin/bash

set -e

curl -k https://sh.rustup.rs -sSf | sh -s -- -y --profile=minimal --default-toolchain 1.62.0