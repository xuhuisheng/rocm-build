#!/bin/bash

export PATH=/opt/rocm/bin:$PATH

mkdir -p build

rm build/test_rocblas2

hipcc -D__HIP_PLATFORM_HCC__ -lrocblas -L/opt/rocm/lib src/test_rocblas2.cpp -o build/test_rocblas2

ROCBLAS_LAYER=0xf TENSILE_DB=0xffff ./build/test_rocblas2


