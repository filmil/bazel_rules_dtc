#! /bin/bash
#
# This script automatically installs the local dependencies needed by
# this project. None of these are version sensitive, so should be OK
# to install.

# Print the commands executed so there is no doubt as to what the script wants
# to do.
set -x

# Google specific deps.
sudo apt-get install git-remote-google

# General deps.
sudo apt-get install \
  autoconf \
  automake \
  bison \
  build-essential \
  check \
  clang \
  libclang-dev \
  flex \
  gtkwave \
  libdw-dev \
  libffi-dev \
  llvm-dev \
  pkg-config \
  python3-pip \
  zlib1g-dev

echo "Loading the Vivado tooling into the docker repo - this takes a while."
docker load \
  -i /google/data/ro/users/fm/fmil/www/files/cp/third_party/xilinx-vivado.docker.tgz
docker images | grep xilinx-vivado
