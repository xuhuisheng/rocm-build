#!/bin/bash

set -e

mkdir -p build/rocm-opencl-runtime
cd build/rocm-opencl-runtime
pushd .

cmake $ROCM_GIT_REPO/ROCm-OpenCL-Runtime \
    -DUSE_COMGR_LIBRARY=ON \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm/opencl \
    -Dhsa-runtime64_DIR=/opt/rocm/lib/cmake/hsa-runtime64 \
    -DROCclr_DIR=/opt/rocm/rocclr \
    -G Ninja
ninja
ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

