#!/bin/bash

set -e

pushd .

scp work@192.168.31.185:/media/work/hgst1/backup-1000/gitrepo/googletest-1.13.0.tar.gz /home/work/local

tar xf /home/work/local/googletest-1.13.0.tar.gz -C /home/work/local/ 

mkdir -p /home/work/local/googletest/build
cd /home/work/local/googletest/build

cmake ..

make -j

sudo make install

popd

