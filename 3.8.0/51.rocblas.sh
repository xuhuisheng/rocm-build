#!/bin/bash

set -e

mkdir -p build/rocblas
cd build/rocblas
pushd .

CXX=hipcc cmake -lpthread $ROCM_GIT_REPO/rocBLAS \
    -DROCM_PATH=/opt/rocm \
    -DTensile_LOGIC=asm_full \
    -DTensile_ARCHITECTURE=gfx803 \
    -DTensile_CODE_OBJECT_VERSION=V3 \
    -DCMAKE_BUILD_TYPE=Release \
    -DTensile_TEST_LOCAL_PATH=/home/work/rocm-deps/Tensile \
    -DBUILD_WITH_TENSILE_HOST=OFF \
    -DTensile_LIBRARY_FORMAT=yaml \
    -DRUN_HEADER_TESTING=OFF \
    -DTensile_COMPILER=hipcc \
    -DCPACK_SET_DESTDIR=OFF \
    -DCMAKE_INSTALL_PREFIX=rocblas-install \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm \
    -DCPACK_GENERATOR=DEB \
    -G Ninja
ninja
ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

