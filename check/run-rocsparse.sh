#!/bin/bash

export PATH=/opt/rocm/bin:$PATH

mkdir -p build

hipcc -D__HIP_PLATFORM_HCC__ -lrocsparse -lhipsparse -L/opt/rocm/lib src/test_rocsparse.cpp -o build/test_rocsparse

ROCBLAS_LAYER=0xf TENSILE_DB=0xffff ./build/test_rocsparse


