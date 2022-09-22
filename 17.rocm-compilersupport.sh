#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/rocm-compilersupport
cd $ROCM_BUILD_DIR/rocm-compilersupport
pushd .

cd $ROCM_GIT_DIR/ROCm-CompilerSupport
git reset --hard
git apply $ROCM_PATCH_DIR/17.rocm-compilersupport-ubuntu2004-1.patch
cd $ROCM_BUILD_DIR/rocm-compilersupport

START_TIME=`date +%s`

cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    -B build \
    $ROCM_GIT_DIR/ROCm-CompilerSupport/lib/comgr

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

