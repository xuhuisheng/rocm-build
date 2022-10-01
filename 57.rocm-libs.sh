#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/rocm-libs
cd $ROCM_BUILD_DIR/rocm-libs
pushd .

START_TIME=`date +%s`

cmake \
  -DCMAKE_INSTALL_PREFIX=${ROCM_INSTALL_DIR} \
  -DPROJECT_VERSION_MAJOR=${ROCM_MAJOR_VERSION} \
  -DPROJECT_VERSION_MINOR=${ROCM_MINOR_VERSION} \
  -DPROJECT_VERSION_PATCH=${ROCM_PATCH_VERSION} \
  -DROCM_PATCH_VERSION=${ROCM_LIBPATCH_VERSION} \
  -DROCM_BUILD_VERSION=${CPACK_DEBIAN_PACKAGE_RELEASE} \
  $ROCM_BUILD_DIR/../src/rocm-libs

cmake --build . --target package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

