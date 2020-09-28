#!/bin/bash

set -e

mkdir -p build/roct-thunk-interface
cd build/roct-thunk-interface
pushd .
cmake $ROCM_GIT_REPO/ROCT-Thunk-Interface/ \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm/ \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm/ \
    -DCPACK_GENERATOR=DEB \
    -G Ninja
ninja
# make package -j${nproc}

popd

