#!/bin/bash

set -e

mkdir -p build/rocm_smi_lib
cd build/rocm_smi_lib
pushd .

cmake $ROCM_GIT_REPO/rocm_smi_lib \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm/ \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm/ \
    -DCPACK_GENERATOR=DEB \
    -G Ninja
ninja
# make package -j${nproc}

popd

