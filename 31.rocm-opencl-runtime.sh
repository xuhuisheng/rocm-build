#!/bin/bash

set -e

mkdir -p $ROCM_GIT_DIR

cd $ROCM_GIT_DIR


git clone -b $ROCM_GIT_TAG https://github.com/ROCm-Developer-Tools/ROCclr.git

git clone -b $ROCM_GIT_TAG  https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime.git


mkdir -p $ROCM_BUILD_DIR/rocm-opencl-runtime
cd $ROCM_BUILD_DIR/rocm-opencl-runtime
pushd .

cd $ROCM_GIT_DIR/ROCclr
git reset --hard
git apply $ROCM_PATCH_DIR/31.rocm-opencl-runtime-rocclr-gfx803-1.patch
cd $ROCM_BUILD_DIR/rocm-opencl-runtime

START_TIME=`date +%s`

cmake \
    -DCMAKE_PREFIX_PATH="$ROCM_INSTALL_DIR" \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR/opencl \
    -Dhsa-runtime64_DIR=$ROCM_INSTALL_DIR/lib/cmake/hsa-runtime64 \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR/opencl \
    -G Ninja \
    $ROCM_GIT_DIR/ROCm-OpenCL-Runtime
ninja
ninja package

popd

