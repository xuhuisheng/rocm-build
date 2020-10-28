#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/hipblas
cd $ROCM_BUILD_DIR/hipblas
pushd .

CXX=$ROCM_INSTALL_DIR/hip/bin/hipcc cmake \
    -DAMDGPU_TARGETS=$AMDGPU_TARGETS \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_SET_DESTDIR=OFF \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_INSTALL_PREFIX=hipsparse-install \
    $ROCM_GIT_DIR/hipBLAS
make -j${nproc}
make package
sudo dpkg -i *.deb

popd

