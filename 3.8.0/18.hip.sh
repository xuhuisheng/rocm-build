#!/bin/bash

set -e

sudo apt install -y rpm libfile-which-perl kmod doxygen

mkdir -p build/hip
cd build/hip
pushd .

cmake $ROCM_GIT_REPO/HIP \
    -DCMAKE_BUILD_TYPE=Release \
    -DHIP_COMPILER=clang \
    -DHIP_PLATFORM=rocclr \
    -DCMAKE_PREFIX_PATH=/opt/rocm/ \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm/hip/ \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm/hip/ \
    -DCPACK_GENERATOR=DEB \
    -G Ninja
sudo ninja
sudo ninja install
sudo ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

