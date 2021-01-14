#!/bin/bash

export PATH=/opt/rocm/bin:$PATH

mkdir -p build

hipcc -D__HIP_PLATFORM_HCC__ -L/opt/rocm/lib/ -lMIOpen src/test_miopen.cpp -o build/test_miopen

MIOPEN_ENABLE_LOGGING=0 MIOPEN_LOG_LEVEL=0 ./build/test_miopen


