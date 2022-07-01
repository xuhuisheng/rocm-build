#!/bin/bash

set -e

pushd .

mkdir -p /home/work/local

scp meicai@192.168.31.185:/media/meicai/hgst1/backup-1000/ai/cmake-3.16.8-Linux-x86_64.tar.gz /home/work/local

tar xzf /home/work/local/cmake-3.16.8-Linux-x86_64.tar.gz -C /home/work/local/

popd

