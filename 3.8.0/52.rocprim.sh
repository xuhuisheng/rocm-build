#!/bin/bash

set -e

mkdir -p build/rocprim
cd build/rocprim
pushd .

CXX=/opt/rocm/bin/hipcc cmake $ROCM_GIT_REPO/rocPRIM \
    -DBUILD_BENCHMARK=OFF \
    -DBUILD_TEST=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_GENERATOR=DEB \
    -G Ninja
ninja
# make package -j${nproc}

popd

