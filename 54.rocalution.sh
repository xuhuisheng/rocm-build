#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/rocalution
cd $ROCM_BUILD_DIR/rocalution
pushd .

cd $ROCM_GIT_DIR/rocALUTION
git reset --hard
git apply $ROCM_PATCH_DIR/54.rocalution-annotation-1.patch
cd $ROCM_BUILD_DIR/rocalution

START_TIME=`date +%s`

CXX=$ROCM_INSTALL_DIR/hip/bin/hipcc cmake \
    -DAMDGPU_TARGETS=$AMDGPU_TARGETS \
    -DCMAKE_BUILD_TYPE=Release \
    -DSUPPORT_HIP=ON \
    -DROCM_PATH=$ROCM_INSTALL_DIR \
    -DCPACK_SET_DESTDIR=OFF \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_INSTALL_PREFIX=rocalution-install \
    -G Ninja \
    $ROCM_GIT_DIR/rocALUTION

cmake --build .
cmake --build . --target package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

