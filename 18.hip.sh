#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/hip
cd $ROCM_BUILD_DIR/hip
pushd .

ROCclr_DIR=$ROCM_GIT_DIR/ROCclr
OPENCL_DIR=$ROCM_GIT_DIR/ROCm-OpenCL-Runtime
HIP_DIR=$ROCM_GIT_DIR/HIP

START_TIME=`date +%s`

# There are some perl scripts that require this envar
HIP_CLANG_PATH="$ROCM_INSTALL_DIR/llvm/bin" \
cmake \
    -DOFFLOAD_ARCH_STR="$AMDGPU_TARGETS" \
    -DHIP_CLANG_PATH="$ROCM_INSTALL_DIR/llvm/bin" \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DHIP_COMMON_DIR="$HIP_DIR" \
    -DAMD_OPENCL_PATH="$OPENCL_DIR" \
    -DROCCLR_PATH="$ROCCLR_DIR" \
    -DCMAKE_PREFIX_PATH="$ROCM_INSTALL_DIR" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_GENERATOR=DEB \
    -DROCM_PATCH_VERSION=50100 \
    -DROCM_PATH="$ROCM_INSTALL_DIR" \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -D__HIP_ENABLE_PCH=OFF \
    -G Ninja \
    -B build \
    $ROCM_GIT_DIR/hipamd

if [[ $1 = "--cmake-install" ]]; then
  echo "Cmake install into ${CMAKE_INSTALL_PREFIX}"
  cmake --build build --target install
else
  echo "deb package install"
  cmake --build build
  cmake --build build --target package
  sudo dpkg -i hip-dev*.deb hip-doc*.deb hip-runtime-amd*.deb hip-samples*.deb
fi

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

