#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/rocm-opencl-runtime
cd $ROCM_BUILD_DIR/rocm-opencl-runtime
pushd .

START_TIME=`date +%s`

cmake \
    -DCMAKE_PREFIX_PATH="$ROCM_INSTALL_DIR" \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR/opencl \
    -Dhsa-runtime64_DIR=$ROCM_INSTALL_DIR/lib/cmake/hsa-runtime64 \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR/opencl \
    -G Ninja \
    $ROCM_GIT_DIR/ROCm-OpenCL-Runtime

cmake --build .
cmake --build . --target package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

