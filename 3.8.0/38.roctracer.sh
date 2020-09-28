#!/bin/bash

set -e

mkdir -p build/roctracer
cd build/roctracer
pushd .

ROCTRACER_ROOT=$ROCM_GIT_REPO/roctracer
BUILD_TYPE=Release
PREFIX_PATH=/opt/rocm
PACKAGE_ROOT=/opt/rocm
PACKAGE_PREFIX=/opt/rocm
LD_RUNPATH_FLAG="-Wl,--enable-new-dtags -Wl,--rpath,/opt/rocm/lib:/opt/rocm/lib64"
HIP_VDI=1
HIP_API_STRING=1

cmake \
    -DCMAKE_MODULE_PATH=$ROCTRACER_ROOT/cmake_modules \
    -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
    -DCMAKE_PREFIX_PATH="$PREFIX_PATH" \
    -DCMAKE_INSTALL_PREFIX=$PACKAGE_ROOT \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$PACKAGE_PREFIX \
    -DCPACK_GENERATOR="DEB" \
    -DCMAKE_SHARED_LINKER_FLAGS="$LD_RUNPATH_FLAG" \
    -DHIP_VDI="$HIP_VDI" \
    -DHIP_API_STRING="$HIP_API_STRING" \
    $ROCTRACER_ROOT

ninja
# make package -j${nproc}

popd

