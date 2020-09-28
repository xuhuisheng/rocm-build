#!/bin/bash

set -e

mkdir -p build/clang-ocl
cd build/clang-ocl
pushd .

cmake $ROCM_GIT_REPO/clang-ocl \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm/ \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm/ \
    -DCPACK_GENERATOR=DEB \
    -G Ninja
ninja
ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

