#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/rocdbgapi
cd $ROCM_BUILD_DIR/rocdbgapi
pushd .

START_TIME=`date +%s`

cd $ROCM_GIT_DIR/ROCdbgapi
git reset --hard
patch -p1 -N < $ROCM_PATCH_DIR/42.rocdbgapi.patch
cd $ROCM_BUILD_DIR/rocdbgapi

cmake \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    $ROCM_GIT_DIR/ROCdbgapi
ninja
ninja package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

