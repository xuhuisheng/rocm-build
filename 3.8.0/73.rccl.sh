#!/bin/bash

set -e

mkdir -p build/rccl
cd build/rccl
pushd .

CXX=/opt/rocm/bin/hipcc cmake $ROCM_GIT_REPO/rccl \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_TESTS=OFF \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm \
    -G Ninja
ninja
ninja package 
sudo dpkg -i *.deb
# make package -j${nproc}

popd

