#!/bin/bash

set -e

mkdir -p build/rocsolver
cd build/rocsolver
pushd .

CXX=/opt/rocm/hip/bin/hipcc cmake $ROCM_GIT_REPO/rocSOLVER \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_SET_DESTDIR=OFF \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm \
    -DCMAKE_INSTALL_PREFIX=hipsparse-install \
    -G Ninja
ninja
ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

