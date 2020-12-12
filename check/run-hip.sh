#!/bin/bash

export PATH=/opt/rocm/bin:$PATH

mkdir -p build

hipcc -D__HIP_PLATFORM_HCC__ src/test_hip.cpp -o build/test_hip

AMD_LOG_LEVEL=0 ./build/test_hip


