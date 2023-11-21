#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/hipcc
cd $ROCM_BUILD_DIR/hipcc
pushd .

START_TIME=`date +%s`

cmake \
    -DOFFLOAD_ARCH_STR="--offload-arch=$AMDGPU_TARGETS" \
    -DCMAKE_PREFIX_PATH="$ROCM_INSTALL_DIR" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_GENERATOR=DEB \
    -DCMAKE_INSTALL_PREFIX=$ROCM_BUILD_DIR/hipcc/install \
    -G Ninja \
    $ROCM_GIT_DIR/HIPCC

cmake --build .
cmake --build . --target package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

