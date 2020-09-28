#!/bin/bash

set -e

mkdir -p build/rocclr
cd build/rocclr
pushd .

# export ROCclr_DIR="$(readlink -f ROCclr)"
# export OPENCL_DIR="$(readlink -f ROCm-OpenCL-Runtime)"
export ROCclr_DIR=$ROCM_GIT_REPO/ROCclr
export OPENCL_DIR=$ROCM_GIT_REPO/ROCm-OpenCL-Runtime

cmake $ROCM_GIT_REPO/ROCclr \
    -DOPENCL_DIR="$OPENCL_DIR" \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm/rocclr/ \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm/rocclr/ \
    -DCPACK_GENERATOR=DEB \
    -G Ninja
ninja
# make package -j${nproc}

popd

