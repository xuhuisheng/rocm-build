#!/bin/bash

set -e

sudo cmake -P $ROCM_GIT_DIR/MIOpen/install_deps.cmake --minimum --prefix /usr/local

mkdir -p $ROCM_BUILD_DIR/miopen
cd $ROCM_BUILD_DIR/miopen
pushd .

START_TIME=`date +%s`

CXX=$ROCM_INSTALL_DIR/llvm/bin/clang++ cmake \
    -DAMDGPU_TARGETS=$AMDGPU_TARGETS \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_SET_DESTDIR=OFF \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -G Ninja \
    $ROCM_GIT_DIR/MIOpen
ninja
ninja package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

