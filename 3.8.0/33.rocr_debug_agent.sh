#!/bin/bash

set -e

sudo apt install -y libdw-dev

mkdir -p build/rocr_debug_agent
cd build/rocr_debug_agent
pushd .

cd $ROCM_GIT_REPO/rocr_debug_agent
patch -p1 < /home/work/rocm-build/3.8.0/patch/33.rocr_debug_agent.patch
cd /home/work/rocm-build/3.8.0/build/rocr_debug_agent

cmake $ROCM_GIT_REPO/rocr_debug_agent \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm/ \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm/ \
    -DCPACK_GENERATOR=DEB \
    -G Ninja
ninja
ninja package
sudo dpkg -i *.deb

# make package -j${nproc}

popd

