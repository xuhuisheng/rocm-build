#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/miopen
cd $ROCM_BUILD_DIR/miopen
pushd .

START_TIME=`date +%s`

cmake \
    -DMIOPEN_USE_COMPOSABLEKERNEL=OFF \
    -DAMDGPU_TARGETS=$AMDGPU_TARGETS \
    -DCMAKE_BUILD_TYPE=Release \
    -DMIOPEN_USE_MLIR=0 \
    -DCPACK_SET_DESTDIR=OFF \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -G Ninja \
    $ROCM_GIT_DIR/MIOpen

cmake --build .
cmake --build . --target package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

