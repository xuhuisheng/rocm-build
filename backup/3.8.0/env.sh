#!/bin/bash

export ROCM_INSTALL_DIR=/opt/rocm
export ROCM_GIT_DIR=/home/work/ROCm
export ROCM_BUILD_DIR=/home/work/rocm-build/backup/3.8.0/build
export ROCM_PATCH_DIR=/home/work/rocm-build/backup/3.8.0/patch
export AMDGPU_TARGETS="gfx803;gfx900;gfx906"
export PATH=$ROCM_INSTALL_DIR/bin:$ROCM_INSTALL_DIR/llvm/bin:$ROCM_INSTALL_DIR/hip/bin:$PATH

