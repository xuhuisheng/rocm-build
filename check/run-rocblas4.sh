#!/bin/bash

export PATH=/opt/rocm/bin:$PATH

mkdir -p build

rm build/test_rocblas4

hipcc -D__HIP_PLATFORM_HCC__ -lrocblas -L/opt/rocm/lib src/test_rocblas4.cpp -o build/test_rocblas4

# ROCBLAS_LAYER=0xf TENSILE_DB=0xffff ./build/test_rocblas3
./build/test_rocblas4


