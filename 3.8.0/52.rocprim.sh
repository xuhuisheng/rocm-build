#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/rocprim
cd $ROCM_BUILD_DIR/rocprim
pushd .

CXX=$ROCM_INSTALL_DIR/bin/hipcc cmake \
    -DBUILD_BENCHMARK=OFF \
    -DBUILD_TEST=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    $ROCM_GIT_DIR/rocPRIM
ninja
ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

