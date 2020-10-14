#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/clang-ocl
cd $ROCM_BUILD_DIR/clang-ocl
pushd .

cmake \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    $ROCM_GIT_DIR/clang-ocl
ninja
ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

