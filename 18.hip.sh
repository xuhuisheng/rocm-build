#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/hip
cd $ROCM_BUILD_DIR/hip
pushd .

ROCclr_DIR=$ROCM_GIT_DIR/clr/rocclr
OPENCL_DIR=$ROCM_GIT_DIR/clr/opencl
HIP_DIR=$ROCM_GIT_DIR/HIP

START_TIME=`date +%s`

cmake \
    -DOFFLOAD_ARCH_STR="--offload-arch=$AMDGPU_TARGETS" \
    -DHIP_COMMON_DIR="$HIP_DIR" \
    -DCLR_BUILD_HIP=ON \
    -DCMAKE_PREFIX_PATH="$ROCM_INSTALL_DIR" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_GENERATOR=DEB \
    -DCMAKE_INSTALL_PREFIX=$ROCM_BUILD_DIR/hip/install \
    -DHIPCC_BIN_DIR="$ROCM_GIT_DIR/HIPCC/build" \
    -G Ninja \
    $ROCM_GIT_DIR/clr

cmake --build .
cmake --build . --target package
sudo dpkg -i hip-dev*.deb hip-doc*.deb hip-runtime-amd*.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

