#!/bin/bash

set -e

pushd .

scp work@192.168.31.185:/media/work/hgst1/backup-1000/gitrepo/fmt-7.1.3.tar.gz /home/work/local

tar xf /home/work/local/fmt-7.1.3.tar.gz -C /home/work/local/ 

mkdir -p /home/work/local/fmt/build
cd /home/work/local/fmt/build

cmake .. -DFMT_DOC=OFF -DFMT_TEST=OFF

make -j

sudo make install

popd

