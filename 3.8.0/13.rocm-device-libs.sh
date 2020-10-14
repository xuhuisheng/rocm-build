#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/rocm-device-libs
cd $ROCM_BUILD_DIR/rocm-device-libs
pushd .
cmake \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    $ROCM_GIT_DIR/ROCm-Device-Libs
ninja
ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

