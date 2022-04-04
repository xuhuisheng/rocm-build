#!/bin/bash

set -e

SRC_DIR=/home/work/llvm-project-mlir

mkdir -p $ROCM_BUILD_DIR/miopen-mlir
cd $ROCM_BUILD_DIR/miopen-mlir
pushd .

cd $SRC_DIR
git checkout release/rocm-5.1
cd $ROCM_BUILD_DIR/miopen-mlir

START_TIME=`date +%s`

cmake \
    -DBUILD_FAT_LIBMLIRMIOPEN=1 \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_GENERATOR=DEB \
    -DCPACK_DEBIAN_PACKAGE_MAINTAINER=amd \
    -G Ninja \
    $SRC_DIR
ninja
ninja package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

