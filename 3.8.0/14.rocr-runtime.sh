#!/bin/bash

set -e

sudo apt install -y libelf-dev

mkdir -p $ROCM_BUILD_DIR/rocr-runtime
cd $ROCM_BUILD_DIR/rocr-runtime
pushd .
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    $ROCM_GIT_DIR/ROCR-Runtime/src
ninja
ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

