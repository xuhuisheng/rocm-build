#!/bin/bash

export PATH=/opt/rocm/bin:$PATH

mkdir -p build

rm build/test_rocblas3

hipcc -D__HIP_PLATFORM_HCC__ -Iinclude -lrocblas -L/opt/rocm/lib src/test_rocblas3.cpp -o build/test_rocblas3

# ROCBLAS_LAYER=0xf TENSILE_DB=0xffff ./build/test_rocblas3
./build/test_rocblas3


