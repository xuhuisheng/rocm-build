#!/bin/bash

set -e

mkdir -p $ROCM_BUILD_DIR/meta
cd $ROCM_BUILD_DIR/meta
pushd .

cp ../../rocm-utils-3.8.0_amd64 . -R
cp ../../rocm-dev-3.8.0_amd64 . -R

dpkg -b rocm-utils-3.8.0_amd64
dpkg -b rocm-dev-3.8.0_amd64

sudo dpkg -i *.deb
# make package -j${nproc}

popd

