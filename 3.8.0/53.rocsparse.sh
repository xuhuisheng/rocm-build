#!/bin/bash

set -e

mkdir -p build/rocsparse
cd build/rocsparse
pushd .

CXX=/opt/rocm/hip/bin/hipcc cmake $ROCM_GIT_REPO/rocSPARSE \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_SET_DESTDIR=OFF \
    -DCMAKE_INSTALL_PREFIX=rocsparse-install \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm \
    -DROCM_PATH=/opt/rocm \
    -G Ninja
ninja
ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

