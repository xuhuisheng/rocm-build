#!/bin/bash

set -e

pushd .

scp work@192.168.31.185:/media/work/hgst1/backup-1000/ai/boost_1_72_0.tar.bz2 /home/work/local
scp work@192.168.31.185:/media/work/hgst1/backup-1000/ai/boost.cmake /home/work/local

tar xf /home/work/local/boost_1_72_0.tar.bz2 -C /home/work/local/

cp /home/work/local/boost.cmake /home/work/local/boost_1_72_0/CMakeLists.txt

mkdir -p /home/work/local/boost_1_72_0/build
cd /home/work/local/boost_1_72_0/build

cmake .. -DBOOST_WITHOUT_CONTEXT=1 -DBOOST_WITHOUT_COROUTINE=1 -DBOOST_WITHOUT_PYTHON=1 -DCMAKE_POSITION_INDEPENDENT_CODE=ON

make -j

sudo make install

popd

