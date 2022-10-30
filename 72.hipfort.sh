#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/hipfort
cd $ROCM_BUILD_DIR/hipfort
pushd .

START_TIME=`date +%s`

CXX=$ROCM_INSTALL_DIR/hip/bin/hipcc cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_SET_DESTDIR=OFF \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_INSTALL_PREFIX=hipfort-install \
    -G "Unix Makefiles" \
    $ROCM_GIT_DIR/hipfort

cmake --build . -j
cmake --build . --target package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

