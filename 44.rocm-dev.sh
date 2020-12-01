#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/meta
cd $ROCM_BUILD_DIR/meta
pushd .

START_TIME=`date +%s`

# cp ../../rocm-utils-3.8.0_amd64 . -R
cp ../../rocm-dev-3.10.0_amd64 . -R

# dpkg -b rocm-utils-3.8.0_amd64
dpkg -b rocm-dev-3.10.0_amd64

sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

