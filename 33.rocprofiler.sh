#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/rocprofiler
cd $ROCM_BUILD_DIR/rocprofiler
pushd .

cd $ROCM_GIT_DIR/rocprofiler
git reset --hard
git apply $ROCM_PATCH_DIR/33.rocprofile-aql.patch
cd $ROCM_BUILD_DIR/rocprofiler

START_TIME=`date +%s`

cmake \
    -DPROF_API_HEADER_PATH=$ROCM_GIT_DIR/roctracer/inc/ext/ \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    $ROCM_GIT_DIR/rocprofiler

cmake --build .
cmake --build . --target package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

