#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/rocm_smi_lib
cd $ROCM_BUILD_DIR/rocm_smi_lib
pushd .

cd $ROCM_GIT_DIR/rocm_smi_lib
git reset --hard
git apply $ROCM_PATCH_DIR/27.rocm_smi_lib-version-1.patch
cd $ROCM_BUILD_DIR/rocm_smi_lib

START_TIME=`date +%s`

cmake \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    $ROCM_GIT_DIR/rocm_smi_lib

cmake --build .
cmake --build . --target package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

