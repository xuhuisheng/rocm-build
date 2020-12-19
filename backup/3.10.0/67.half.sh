#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/half
cd $ROCM_BUILD_DIR/half
pushd .

# git clone https://github.com/ROCmSoftwarePlatform/half

START_TIME=`date +%s`

cp -R ../../half_1.12.0_amd64 $ROCM_BUILD_DIR/half/

# mkdir -p $ROCM_BUILD_DIR/half/half_1.12.0_amd64/opt/rocm/

# cp -R $ROCM_BUILD_DIR/half/half/include $ROCM_BUILD_DIR/half/half_1.12.0_amd64/opt/rocm/

dpkg -b half_1.12.0_amd64

sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

