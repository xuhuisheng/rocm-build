#!/bin/bash

export PATH=/opt/rocm/bin:$PATH

mkdir -p build

hipcc -D__HIP_PLATFORM_HCC__ -I./src/ -L/opt/rocm/lib/ -lMIOpen -std=c++11 src/test_miopen_img.cpp src/libbmp.cpp -o build/test_miopen_img

MIOPEN_ENABLE_LOGGING=0 MIOPEN_LOG_LEVEL=0 ./build/test_miopen_img


