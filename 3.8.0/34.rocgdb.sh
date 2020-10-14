#!/bin/bash

set -e

sudo apt install -y bison flex gcc make ncurses-dev texinfo g++ zlib1g-dev \
  libexpat-dev python3-dev liblzma-dev libbabeltrace-dev \
  libbabeltrace-ctf-dev

mkdir -p $ROCM_BUILD_DIR/rocgdb
cd $ROCM_BUILD_DIR/rocgdb
pushd .

$ROCM_GIT_DIR/ROCgdb/configure --program-prefix=roc \
  --enable-64-bit-bfd --enable-targets="x86_64-linux-gnu,amdgcn-amd-amdhsa" \
  --disable-ld --disable-gas --disable-gdbserver --disable-sim --enable-tui \
  --disable-gdbtk --disable-shared --with-expat --with-system-zlib \
  --without-guile --with-babeltrace --with-lzma --with-python=python3
make -j${nproc}

popd


