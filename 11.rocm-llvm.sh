#!/bin/bash

set -e

echo "|====|"
echo "|SLOW|"
echo "|====|"

mkdir -p $ROCM_BUILD_DIR/llvm-amdgpu
cd $ROCM_BUILD_DIR/llvm-amdgpu
pushd .

START_TIME=`date +%s`

cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR/llvm/ \
    -DLLVM_ENABLE_ASSERTIONS=1 \
    -DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" \
    -DLLVM_ENABLE_PROJECTS="compiler-rt;lld;clang" \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR/llvm/ \
    -DCPACK_GENERATOR=DEB \
    -DCPACK_DEBIAN_PACKAGE_MAINTAINER=amd \
    -DCPACK_PACKAGE_NAME=rocm-llvm \
    -DPACKAGE_VERSION=15.0.0.22465.${ROCM_LIBPATCH_VERSION}-${CPACK_DEBIAN_PACKAGE_RELEASE} \
    -DCPACK_DEBIAN_FILE_NAME=DEB-DEFAULT \
    -G Ninja \
    $ROCM_GIT_DIR/llvm-project/llvm

cmake --build .
cmake --build . --target package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

