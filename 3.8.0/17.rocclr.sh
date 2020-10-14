#!/bin/bash

set -e

sudo apt install -y mesa-common-dev

mkdir -p $ROCM_BUILD_DIR/rocclr
cd $ROCM_BUILD_DIR/rocclr
pushd .

# export ROCclr_DIR="$(readlink -f ROCclr)"
# export OPENCL_DIR="$(readlink -f ROCm-OpenCL-Runtime)"
export ROCclr_DIR=$ROCM_GIT_DIR/ROCclr
export OPENCL_DIR=$ROCM_GIT_DIR/ROCm-OpenCL-Runtime

cmake \
    -DOPENCL_DIR="$OPENCL_DIR" \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR/rocclr/ \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR/rocclr/ \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    $ROCM_GIT_DIR/ROCclr
ninja
sudo ninja install
# make package -j${nproc}

popd

