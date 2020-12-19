#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/rccl
cd $ROCM_BUILD_DIR/rccl
pushd .

START_TIME=`date +%s`

CXX=$ROCM_INSTALL_DIR/bin/hipcc cmake \
    -DAMDGPU_TARGETS=$AMDGPU_TARGETS \
    -DHIP_CLANG_INCLUDE_PATH=$ROCM_INSTALL_DIR/llvm/include \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_TESTS=OFF \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -G Ninja \
    $ROCM_GIT_DIR/rccl
ninja
ninja package 
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

