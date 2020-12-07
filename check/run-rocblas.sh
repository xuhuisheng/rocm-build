#!/bin/bash

export PATH=/opt/rocm/bin:$PATH

hipcc -D__HIP_PLATFORM_HCC__ -lrocblas -L/opt/rocm/lib test_rocblas.cpp -o test_rocblas

./test_rocblas


