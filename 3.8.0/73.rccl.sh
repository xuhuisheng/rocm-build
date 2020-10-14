#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/rccl
cd $ROCM_BUILD_DIR/rccl
pushd .

CXX=$ROCM_INSTALL_DIR/bin/hipcc cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_TESTS=OFF \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -G Ninja \
    $ROCM_GIT_DIR/rccl
ninja
ninja package 
sudo dpkg -i *.deb
# make package -j${nproc}

popd

