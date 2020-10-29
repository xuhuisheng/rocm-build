#!/bin/bash

set -e

echo "|====|"
echo "|SLOW|"
echo "|====|"

sudo apt install -y gfortran

mkdir -p $ROCM_BUILD_DIR/rocblas
cd $ROCM_BUILD_DIR/rocblas
pushd .

cd $ROCM_GIT_DIR/rocBLAS
bash $ROCM_GIT_DIR/rocBLAS/install.sh -d

CXX=$ROCM_INSTALL_DIR/bin/hipcc cmake -lpthread \
    -DAMDGPU_TARGETS=$AMDGPU_TARGETS \
    -DROCM_PATH=$ROCM_INSTALL_DIR \
    -DTensile_LOGIC=asm_full \
    -DTensile_ARCHITECTURE=all \
    -DTensile_CODE_OBJECT_VERSION=V3 \
    -DCMAKE_BUILD_TYPE=Release \
    -DTensile_LIBRARY_FORMAT=yaml \
    -DRUN_HEADER_TESTING=OFF \
    -DTensile_COMPILER=hipcc \
    -DCPACK_SET_DESTDIR=OFF \
    -DCMAKE_INSTALL_PREFIX=rocblas-install \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_GENERATOR=DEB \
    $ROCM_GIT_DIR/rocBLAS
make -j${nproc}
make package
sudo dpkg -i *.deb

popd

