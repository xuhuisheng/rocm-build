#!/bin/bash

set -e

mkdir -p build/rocthrust
cd build/rocthrust
pushd .

CXX=/opt/rocm/hip/bin/hipcc cmake $ROCM_GIT_REPO/rocThrust \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_SET_DESTDIR=OFF \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm \
    -DCMAKE_INSTALL_PREFIX=hipsparse-install \
    -G Ninja
ninja
# make package -j${nproc}

popd

