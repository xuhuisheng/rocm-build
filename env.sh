#!/bin/bash

export ROCM_INSTALL_DIR=/opt/rocm-5.2.1
export ROCM_MAJOR_VERSION=5
export ROCM_MINOR_VERSION=2
export ROCM_PATCH_VERSION=1
export ROCM_LIBPATCH_VERSION=50201
export CPACK_DEBIAN_PACKAGE_RELEASE=65
export ROCM_PKGTYPE=RPM
export ROCM_GIT_DIR=~/rocm-build/git
export ROCM_GIT_TAG=rocm-5.2.x
export ROCM_BUILD_DIR=~/rocm-build/build
export ROCM_PATCH_DIR=~/rocm-build/patch
#export AMDGPU_TARGETS="gfx803"
#export CMAKE_DIR=~/local/cmake-3.16.8-Linux-x86_64
#export PATH=$ROCM_INSTALL_DIR/bin:$ROCM_INSTALL_DIR/llvm/bin:$ROCM_INSTALL_DIR/hip/bin:$CMAKE_DIR/bin:$PATH

