#!/bin/bash

set -e

pushd .

scp work@192.168.31.185:/media/work/hgst1/backup-1000/gitrepo/json-3.9.1.tar.gz /home/work/local

tar xf /home/work/local/json-3.9.1.tar.gz -C /home/work/local/ 

mkdir -p /home/work/local/json/build
cd /home/work/local/json/build

cmake .. -DJSON_MultipleHeaders=ON -DJSON_BuildTests=Off

make -j

sudo make install

popd

