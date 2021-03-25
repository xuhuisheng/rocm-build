#!/bin/bash

set -e

sudo CXX=$ROCM_INSTALL_DIR/llvm/bin/clang++ cmake -P $ROCM_GIT_DIR/AMDMIGraphX/install_deps.cmake --prefix /usr/local

mkdir -p $ROCM_BUILD_DIR/amdmigraphx
cd $ROCM_BUILD_DIR/amdmigraphx
pushd .

START_TIME=`date +%s`

CXX=$ROCM_INSTALL_DIR/llvm/bin/clang++ cmake \
    -DAMDGPU_TARGETS=$AMDGPU_TARGETS \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -G Ninja \
    $ROCM_GIT_DIR/AMDMIGraphX
ninja
ninja package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

