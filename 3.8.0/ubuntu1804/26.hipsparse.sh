#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/hipsparse
cd $ROCM_BUILD_DIR/hipsparse
pushd .

CXX=$ROCM_INSTALL_DIR/bin/hipcc cmake \
    -DAMDGPU_TARGETS=$AMDGPU_TARGETS \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_SET_DESTDIR=OFF \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DBUILD_CUDA=OFF \
    -DCMAKE_INSTALL_PREFIX=hipsparse-install \
    -DROCM_PATH=$ROCM_INSTALL_DIR \
    $ROCM_GIT_DIR/hipSPARSE
make -j${nproc}
make package
sudo dpkg -i *.deb

popd

