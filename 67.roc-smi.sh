#!/bin/bash

set -e

sudo apt install python3

# mkdir -p $ROCM_BUILD_DIR/roc-smi
cd $ROCM_BUILD_DIR
rm -rf roc-smi

git clone file://${ROCM_GIT_DIR}/ROC-smi roc-smi
cd roc-smi
pushd .

START_TIME=`date +%s`

ROCM_INSTALL_PATH=$ROCM_INSTALL_DIR make deb
sudo dpkg -i build/deb/*.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$EXECUTING_TIME"s"

popd

