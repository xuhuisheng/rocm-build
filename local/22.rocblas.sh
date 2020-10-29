#!/bin/bash

set -e

echo "|====|"
echo "|SLOW|"
echo "|====|"

sudo apt install -y gfortran
#bash $ROCM_GIT_DIR/rocBLAS/install.sh -d

mkdir -p $ROCM_BUILD_DIR/rocblas
cd $ROCM_BUILD_DIR/rocblas
pushd .

cd $ROCM_GIT_DIR/rocBLAS
git reset --hard
patch -p1 -N < $ROCM_PATCH_DIR/22.rocblas.patch
cd $ROCM_BUILD_DIR/rocblas

rm -rf $ROCM_GIT_DIR/rocBLAS/library/src/blas3/Tensile/Logic/asm_full/r9nano*

START_TIME=`date +%s`

CXX=$ROCM_INSTALL_DIR/bin/hipcc cmake -lpthread \
    -DAMDGPU_TARGETS=$AMDGPU_TARGETS \
    -DROCM_PATH=$ROCM_INSTALL_DIR \
    -DTensile_LOGIC=asm_full \
    -DTensile_ARCHITECTURE=gfx803 \
    -DTensile_CODE_OBJECT_VERSION=V3 \
    -DCMAKE_BUILD_TYPE=Release \
    -DTensile_TEST_LOCAL_PATH=/home/work/rocm-deps/Tensile \
    -DBUILD_WITH_TENSILE_HOST=OFF \
    -DTensile_LIBRARY_FORMAT=yaml \
    -DRUN_HEADER_TESTING=OFF \
    -DTensile_COMPILER=hipcc \
    -DCPACK_SET_DESTDIR=OFF \
    -DCMAKE_INSTALL_PREFIX=rocblas-install \
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

