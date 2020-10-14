#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/miopengemm
cd $ROCM_BUILD_DIR/miopengemm
pushd .

CXX=$ROCM_INSTALL_DIR/hip/bin/hipcc cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_SET_DESTDIR=OFF \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -G Ninja \
    $ROCM_GIT_DIR/MIOpenGEMM
ninja
ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

