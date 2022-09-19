#!/bin/bash

set -e

echo "|====|"
echo "|SLOW|"
echo "|====|"

#bash $ROCM_GIT_DIR/rocBLAS/install.sh -d

mkdir -p $ROCM_BUILD_DIR/rocblas
cd $ROCM_BUILD_DIR/rocblas
pushd .

cd $ROCM_GIT_DIR/Tensile
git reset --hard
git apply $ROCM_PATCH_DIR/22.tensile-gfx1010-1.patch
cd $ROCM_BUILD_DIR/rocblas

START_TIME=`date +%s`

CXX=$ROCM_INSTALL_DIR/bin/hipcc cmake \
    -DCMAKE_TOOLCHAIN_FILE=toolchain-linux.cmake \
    -DAMDGPU_TARGETS=$AMDGPU_TARGETS \
    -DROCM_PATH=$ROCM_INSTALL_DIR \
    -DTensile_LOGIC=asm_full \
    -DTensile_ARCHITECTURE=gfx1010 \
    -DTensile_CODE_OBJECT_VERSION=V3 \
    -DTensile_SEPARATE_ARCHITECTURES=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DTensile_TEST_LOCAL_PATH=$ROCM_GIT_DIR/Tensile \
    -DTensile_LIBRARY_FORMAT=msgpack \
    -DRUN_HEADER_TESTING=OFF \
    -DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=ON \
    -DCMAKE_INSTALL_PREFIX=rocblas-install \
    -DCPACK_SET_DESTDIR=OFF \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    $ROCM_GIT_DIR/rocBLAS
ninja
ninja package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

