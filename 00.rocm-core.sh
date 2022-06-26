#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/rocm-core
cd $ROCM_BUILD_DIR/rocm-core
pushd .

START_TIME=`date +%s`

# cp -R ../../meta/rocm-core_5.1.3.50103-66_amd64 .

# dpkg -b rocm-core_5.1.3.50103-66_amd64

cmake $ROCM_BUILD_DIR/../src/rocm-core
make package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

