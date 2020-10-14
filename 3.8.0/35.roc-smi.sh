#!/bin/bash

set -e

#mkdir -p build/roc-smi
#cd build/roc-smi
cd $ROCM_BUILD_DIR

git clone file://${ROCM_GIT_DIR}/ROC-smi roc-smi
cd roc-smi
pushd .

make deb
sudo dpkg -i build/deb/*.deb

popd


