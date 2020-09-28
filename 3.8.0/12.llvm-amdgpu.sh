#!/bin/bash

set -e

mkdir -p build/llvm-amdgpu
cd build/llvm-amdgpu
pushd .
cmake $ROCM_GIT_REPO/llvm_amd-stg-open/llvm \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm/llvm/ \
    -DLLVM_ENABLE_ASSERTIONS=1 \
    -DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" \
    -DLLVM_ENABLE_PROJECTS="compiler-rt;lld;clang" \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm/llvm/ \
    -DCPACK_GENERATOR=DEB \
    -DCPACK_DEBIAN_PACKAGE_MAINTAINER=amd \
    -DCPACK_PACKAGE_NAME=llvm-amdgpu \
    -G Ninja
ninja
# make package -j${nproc}

popd

