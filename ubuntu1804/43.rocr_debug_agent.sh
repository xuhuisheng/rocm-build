#!/bin/bash

set -e

sudo apt install -y libdw-dev

mkdir -p $ROCM_BUILD_DIR/rocr_debug_agent
cd $ROCM_BUILD_DIR/rocr_debug_agent
pushd .

cmake \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    $ROCM_GIT_DIR/rocr_debug_agent
ninja
ninja package
sudo dpkg -i *.deb

# make package -j${nproc}

popd

