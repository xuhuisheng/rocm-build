#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/rocm-device-libs
cd $ROCM_BUILD_DIR/rocm-device-libs
pushd .

START_TIME=`date +%s`

cmake \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    -B build \
    $ROCM_GIT_DIR/ROCm-Device-Libs

if [[ $1 = "--cmake-install" ]]; then
  echo "Cmake install into ${ROCM_INSTALL_DIR}"
  cmake --build build --target install
else
  echo "deb package install"
  cmake --build build --target package
  sudo dpkg -i *.deb
fi

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

