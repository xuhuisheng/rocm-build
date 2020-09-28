#!/bin/bash

set -e

mkdir -p build/rocdbgapi
cd build/rocdbgapi
pushd .

cmake $ROCM_GIT_REPO/ROCdbgapi \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm/ \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm/ \
    -DCPACK_GENERATOR=DEB \
    -G Ninja
ninja
ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

