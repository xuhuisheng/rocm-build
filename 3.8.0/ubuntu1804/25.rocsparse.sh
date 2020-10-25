#!/bin/bash

set -e

echo "|====|"
echo "|SLOW|"
echo "|====|"

mkdir -p $ROCM_BUILD_DIR/rocsparse
cd $ROCM_BUILD_DIR/rocsparse
pushd .

CXX=$ROCM_INSTALL_DIR/bin/hipcc cmake \
    -DAMDGPU_TARGETS=$AMDGPU_TARGETS \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_SET_DESTDIR=OFF \
    -DCMAKE_INSTALL_PREFIX=rocsparse-install \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DROCM_PATH=$ROCM_INSTALL_DIR \
    $ROCM_GIT_DIR/rocSPARSE
make package -j${nproc}
make package
sudo dpkg -i *.deb

popd

