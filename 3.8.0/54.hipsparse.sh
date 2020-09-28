#!/bin/bash

set -e

mkdir -p build/hipsparse
cd build/hipsparse
pushd .

CXX=/opt/rocm/hip/bin/hipcc cmake $ROCM_GIT_REPO/hipSPARSE \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_SET_DESTDIR=OFF \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm \
    -DBUILD_CUDA=OFF \
    -DCMAKE_INSTALL_PREFIX=hipsparse-install \
    -DROCM_PATH=/opt/rocm \
    -G Ninja
ninja
ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

