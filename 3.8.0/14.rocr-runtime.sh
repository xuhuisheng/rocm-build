#!/bin/bash

set -e

sudo apt install -y libelf-dev

mkdir -p build/rocr-runtime
cd build/rocr-runtime
pushd .
cmake $ROCM_GIT_REPO/ROCR-Runtime/src \
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

