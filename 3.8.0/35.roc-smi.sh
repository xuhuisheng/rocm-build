#!/bin/bash

set -e

#mkdir -p build/roc-smi
#cd build/roc-smi
cd build

git clone file://${ROCM_GIT_REPO}/ROC-smi roc-smi
cd roc-smi
pushd .

make deb

popd


