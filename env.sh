#!/bin/bash

export ROCM_INSTALL_DIR=/opt/rocm
export ROCM_MAJOR_VERSION=5
export ROCM_MINOR_VERSION=2
export ROCM_PATCH_VERSION=0
export ROCM_LIBPATCH_VERSION=50200
export CPACK_DEBIAN_PACKAGE_RELEASE=65
export ROCM_PKGTYPE=DEB
export ROCM_GIT_DIR=/home/work/ROCm
export ROCM_BUILD_DIR=/home/work/rocm-build/build
export ROCM_PATCH_DIR=/home/work/rocm-build/patch
export AMDGPU_TARGETS="gfx803"
export CMAKE_DIR=/home/work/local/cmake-3.16.8-Linux-x86_64
export PATH=$ROCM_INSTALL_DIR/bin:$ROCM_INSTALL_DIR/llvm/bin:$ROCM_INSTALL_DIR/hip/bin:$CMAKE_DIR/bin:$PATH

