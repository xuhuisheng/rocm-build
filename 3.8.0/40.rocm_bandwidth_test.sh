#!/bin/bash

set -e

mkdir -p build/rocm_bandwidth_test
cd build/rocm_bandwidth_test
pushd .

cmake $ROCM_GIT_REPO/rocm_bandwidth_test \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm/ \
    -DCMAKE_PREFIX_PATH=/opt/rocm/ \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm/ \
    -DCPACK_GENERATOR=DEB \
    -G Ninja
ninja
# make package -j${nproc}

popd

