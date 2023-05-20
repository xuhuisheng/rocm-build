#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/miopengemm
cd $ROCM_BUILD_DIR/miopengemm
pushd .

START_TIME=`date +%s`

CXX=$ROCM_INSTALL_DIR/llvm/bin/clang++ cmake \
    -DAMDGPU_TARGETS=$AMDGPU_TARGETS \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -G Ninja \
    $ROCM_GIT_DIR/MIOpenGEMM

cmake --build .
cmake --build . --target package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

