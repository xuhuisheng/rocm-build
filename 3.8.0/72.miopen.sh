#!/bin/bash

set -e

sudo cmake -P $ROCM_GIT_REPO/MIOpen/install_deps.cmake --minimum --prefix /usr/local

mkdir -p build/miopen
cd build/miopen
pushd .

CXX=/opt/rocm/llvm/bin/clang++ cmake $ROCM_GIT_REPO/MIOpen \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_SET_DESTDIR=OFF \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm \
    -G Ninja
ninja
ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

