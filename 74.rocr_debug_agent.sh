#!/bin/bash

set -e

sudo apt install -y libdw-dev

mkdir -p $ROCM_BUILD_DIR/rocr_debug_agent
cd $ROCM_BUILD_DIR/rocr_debug_agent
pushd .

#cd $ROCM_GIT_DIR/rocr_debug_agent
#git reset --hard
#patch -p1 -N < $ROCM_PATCH_DIR/43.rocr_debug_agent.patch
#cd $ROCM_BUILD_DIR/rocr_debug_agent

START_TIME=`date +%s`

export CPACK_DEBIAN_PACKAGE_RELEASE=local

cmake \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    $ROCM_GIT_DIR/rocr_debug_agent
ninja
ninja package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

