#!/bin/bash

set -ex

pushd .

cd $ROCM_GIT_DIR/HIP
git reset --hard
git apply $ROCM_PATCH_DIR/18.hip-ubuntu2204-1.patch
cd $ROCM_BUILD_DIR/..

cd $ROCM_GIT_DIR/hipamd
git reset --hard
git apply $ROCM_PATCH_DIR/18.hipamd-ubuntu2204-1.patch
cd $ROCM_BUILD_DIR/..

cd $ROCM_GIT_DIR/rocPRIM
git reset --hard
git apply $ROCM_PATCH_DIR/23.rocprim-ubuntu2204-1.patch
cd $ROCM_BUILD_DIR/..

# cd $ROCM_GIT_DIR/roctracer
# git reset --hard
# git apply $ROCM_PATCH_DIR/33.roctracer-ubuntu2204-1.patch
# cd $ROCM_BUILD_DIR/..

# cd $ROCM_GIT_DIR/rocSOLVER
# git reset --hard
# git apply $ROCM_PATCH_DIR/51.rocsolver-ubuntu2204-1.patch
# cd $ROCM_BUILD_DIR/..

cd $ROCM_GIT_DIR/ROCmValidationSuite
git reset --hard
git apply $ROCM_PATCH_DIR/73.rocmvalidationsuite-ubuntu2204-1.patch
cd $ROCM_BUILD_DIR/..

popd

