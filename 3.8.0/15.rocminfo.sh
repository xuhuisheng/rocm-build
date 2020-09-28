#!/bin/bash

set -e

mkdir -p build/rocminfo
cd build/rocminfo
pushd .
cmake $ROCM_GIT_REPO/rocminfo \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm/ \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm/ \
    -DCPACK_GENERATOR=DEB \
    -G Ninja
ninja
ninja package 
sudo dpkg -i *.deb
# make package -j${nproc}

popd

