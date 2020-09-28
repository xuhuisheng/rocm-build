#!/bin/bash

set -e

mkdir -p build/rocm-compilersupport
cd build/rocm-compilersupport
pushd .
cmake $ROCM_GIT_REPO/ROCm-CompilerSupport/lib/comgr \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm/ \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm/ \
    -DCPACK_GENERATOR=DEB \
    -G Ninja
ninja
ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

