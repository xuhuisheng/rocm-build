#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/roct-thunk-interface
cd $ROCM_BUILD_DIR/roct-thunk-interface
pushd .

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

