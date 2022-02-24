#!/bin/bash

export PATH=/opt/rocm/bin:$PATH

mkdir -p build

hipcc -D__HIP_PLATFORM_HCC__ -lrocfft -lhipfft -L/opt/rocm/lib src/test_rocfft.cpp -o build/test_rocfft

ROCBLAS_LAYER=0xf TENSILE_DB=0xffff ./build/test_rocfft


