#!/bin/bash

set -e

mkdir -p build/rocprofiler
cd build/rocprofiler
pushd .

cmake $ROCM_GIT_REPO/rocprofiler \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm/ \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm/ \
    -DCPACK_GENERATOR=DEB \
    -G Ninja
ninja
# make package -j${nproc}

popd

