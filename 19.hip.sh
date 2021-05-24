#!/bin/bash

set -e

sudo apt install -y rpm libfile-which-perl kmod doxygen
sudo apt install -y libfile-basedir-perl libfile-copy-recursive-perl libfile-listing-perl libhttp-date-perl libipc-system-simple-perl libtimedate-perl liburi-encode-perl

mkdir -p $ROCM_BUILD_DIR/hip
cd $ROCM_BUILD_DIR/hip
pushd .

START_TIME=`date +%s`

cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DHIP_COMPILER=clang \
    -DHIP_PLATFORM=amd \
    -DROCM_PATH=$ROCM_INSTALL_DIR \
    -DHSA_PATH=$ROCM_INSTALL_DIR/hsa \
    -DCPACK_INSTALL_PREFIX=$ROCM_INSTALL_DIR/hip \
    -DCMAKE_PREFIX_PATH="$ROCM_BUILD_DIR/rocclr;$ROCM_INSTALL_DIR" \
    -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_DIR/hip/ \
    -DCPACK_PACKAGING_INSTALL_PREFIX=$ROCM_INSTALL_DIR/hip/ \
    -DCPACK_GENERATOR=DEB \
    -G Ninja \
    $ROCM_GIT_DIR/HIP
ninja
sudo ninja install
ninja package
sudo dpkg -i *.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

