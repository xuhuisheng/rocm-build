#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/hipfft
cd $ROCM_BUILD_DIR/hipfft
pushd .

START_TIME=`date +%s`

CXX=$ROCM_INSTALL_DIR/bin/hipcc cmake \
    -DROCM_PATH=$ROCM_INSTALL_DIR \
    -DHIP_ROOT_DIR=$ROCM_INSTALL_DIR \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_SET_DESTDIR=OFF \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_INSTALL_PREFIX=hipfft-install \
    -G Ninja \
    $ROCM_GIT_DIR/hipFFT

cmake --build .
cmake --build . --target package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

