#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/rocm-dev
cd $ROCM_BUILD_DIR/rocm-dev
pushd .

START_TIME=`date +%s`

cp -R ../../meta/rocm-dev_5.1.0.50100-36_amd64 .

dpkg -b rocm-dev_5.1.0.50100-36_amd64

sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

