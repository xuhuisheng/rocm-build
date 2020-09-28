#!/bin/bash

set -e

mkdir -p build/hipify
cd build/hipify
pushd .

cmake $ROCM_GIT_REPO/HIPIFY \
    -DCMAKE_PREFIX_PATH=/opt/rocm/llvm/ \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm/ \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm/ \
    -DCPACK_GENERATOR=DEB \
    -G Ninja
ninja
# make package -j${nproc}

popd

