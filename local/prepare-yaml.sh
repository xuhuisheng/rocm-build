#!/bin/bash

set -e

pushd .

scp work@192.168.31.185:/media/work/hgst1/backup-1000/gitrepo/yaml-cpp-0.7.0.tar.gz /home/work/local

tar xf /home/work/local/yaml-cpp-0.7.0.tar.gz -C /home/work/local/ 

mkdir -p /home/work/local/yaml-cpp/build
cd /home/work/local/yaml-cpp/build

cmake ..

make -j

sudo make install

popd

