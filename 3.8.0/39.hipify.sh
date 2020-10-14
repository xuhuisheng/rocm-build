#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/hipify
cd $ROCM_BUILD_DIR/hipify
pushd .

cmake \
    -DCMAKE_PREFIX_PATH=$ROCM_INSTALL_DIR/llvm/ \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR/hip/bin \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR/hip/bin \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    $ROCM_GIT_DIR/HIPIFY
ninja
sudo ninja install
ninja package_hipify-clang
sudo dpkg -i *.deb
# ninja package
# sudo dpkg -i *.deb
# make package -j${nproc}

popd

