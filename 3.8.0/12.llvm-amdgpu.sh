#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/llvm-amdgpu
cd $ROCM_BUILD_DIR/llvm-amdgpu
pushd .
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR/llvm/ \
    -DLLVM_ENABLE_ASSERTIONS=1 \
    -DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" \
    -DLLVM_ENABLE_PROJECTS="compiler-rt;lld;clang" \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR/llvm/ \
    -DCPACK_GENERATOR=DEB \
    -DCPACK_DEBIAN_PACKAGE_MAINTAINER=amd \
    -DCPACK_PACKAGE_NAME=llvm-amdgpu \
    -G Ninja \
    $ROCM_GIT_DIR/llvm_amd-stg-open/llvm
ninja
ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

