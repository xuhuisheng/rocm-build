#!/bin/bash

set -e

sudo apt install python3

#mkdir -p build/roc-smi
#cd build/roc-smi
cd $ROCM_BUILD_DIR

git clone file://${ROCM_GIT_DIR}/ROC-smi roc-smi
cd roc-smi
pushd .

START_TIME=`date +%s`

make deb
sudo dpkg -i build/deb/*.deb

END_TIME=`date +%s`
EXECUTING_TIME=`expr $END_TIME - $START_TIME`
echo "elapse : "$(EXECUTING_TIME)"s"

popd

