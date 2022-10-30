#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/roct-thunk-interface
cd $ROCM_BUILD_DIR/roct-thunk-interface
pushd .

cd $ROCM_GIT_DIR/ROCT-Thunk-Interface/
git reset --hard
git apply $ROCM_PATCH_DIR/12.roct-thunk-interface-gfx803-1.patch
cd $ROCM_BUILD_DIR/roct-thunk-interface

START_TIME=`date +%s`

cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_GENERATOR=DEB \
    -G "Ninja" \
    $ROCM_GIT_DIR/ROCT-Thunk-Interface/

cmake --build .
cmake --build . --target package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

