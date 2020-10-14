#!/bin/bash

set -e

sudo apt install -y rpm libfile-which-perl kmod doxygen

mkdir -p $ROCM_BUILD_DIR/hip
cd $ROCM_BUILD_DIR/hip
pushd .

cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DHIP_COMPILER=clang \
    -DHIP_PLATFORM=rocclr \
    -DCMAKE_PREFIX_PATH=$ROCM_INSTALL_DIR \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR/hip/ \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR/hip/ \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    $ROCM_GIT_DIR/HIP
sudo ninja
sudo ninja install
sudo ninja package
sudo dpkg -i *.deb
# make package -j${nproc}

popd

