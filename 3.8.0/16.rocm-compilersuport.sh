#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/rocm-compilersupport
cd $ROCM_BUILD_DIR/rocm-compilersupport
pushd .
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DROCM_DIR=$ROCM_INSTALL_DIR \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    $ROCM_GIT_DIR/ROCm-CompilerSupport/lib/comgr
ninja
ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

