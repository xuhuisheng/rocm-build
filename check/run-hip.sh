#!/bin/bash

export PATH=/opt/rocm/bin:$PATH

mkdir -p build

hipcc -D__HIP_PLATFORM_HCC__ src/test_hip.cpp -o build/test_hip

ROCBLAS_LAYER=0xf TENSILE_DB=0xffff ./build/test_hip


