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
git apply $ROCM_PATCH_DIR/22.tensile-gfx1030-1.patch
cd $ROCM_BUILD_DIR/rocblas

#rm -rf $ROCM_GIT_DIR/rocBLAS/library/src/blas3/Tensile/Logic/asm_full/r9nano*

START_TIME=`date +%s`

#export CPACK_DEBIAN_PACKAGE_RELEASE=93c82939
#export CPACK_RPM_PACKAGE_RELEASE=93c82939

CXX=$ROCM_INSTALL_DIR/bin/hipcc cmake \
    -DAMDGPU_TARGETS=$AMDGPU_TARGETS \
    -DROCM_PATH=$ROCM_INSTALL_DIR \
    -DTensile_LOGIC=asm_full \
    -DTensile_ARCHITECTURE=gfx1030 \
    -DTensile_CODE_OBJECT_VERSION=V3 \
    -DCMAKE_BUILD_TYPE=Release \
    -DTensile_TEST_LOCAL_PATH=$ROCM_GIT_DIR/Tensile \
    -DBUILD_WITH_TENSILE_HOST=ON \
    -DTensile_LIBRARY_FORMAT=yaml \
    -DRUN_HEADER_TESTING=OFF \
    -DTensile_COMPILER=hipcc \
    -DHIP_CLANG_INCLUDE_PATH= $ROCM_INSTALL_DIR/llvm/include \
    -DCPACK_SET_DESTDIR=OFF \
    -DCMAKE_PREFIX_PATH=$ROCM_INSTALL_DIR \
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
