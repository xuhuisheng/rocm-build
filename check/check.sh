#!/bin/bash

export PATH=/opt/rocm/bin:$PATH

mkdir -p build

hipcc -D__HIP_PLATFORM_HCC__ -lrocblas -L/opt/rocm/lib src/hello_rocblas.cpp -o build/hello_rocblas

./build/hello_rocblas

hipcc -D__HIP_PLATFORM_HCC__ -lrocfft -L/opt/rocm/lib src/hello_rocfft.cpp -o build/hello_rocfft

./build/hello_rocfft

hipcc -D__HIP_PLATFORM_HCC__ src/hello_rocprim.cpp -o build/hello_rocprim

./build/hello_rocprim

hipcc -D__HIP_PLATFORM_HCC__ -lrocrand -L/opt/rocm/lib src/hello_rocrand.cpp -o build/hello_rocrand

./build/hello_rocrand

hipcc -D__HIP_PLATFORM_HCC__ -lrocsparse -L/opt/rocm/lib src/hello_rocsparse.cpp -o build/hello_rocsparse

./build/hello_rocsparse

hipcc -D__HIP_PLATFORM_HCC__ -lrccl -L/opt/rocm/lib src/hello_rccl.cpp -o build/hello_rccl

./build/hello_rccl

hipcc -D__HIP_PLATFORM_HCC__ -lMIOpen -L/opt/rocm/lib src/hello_miopen.cpp -o build/hello_miopen

./build/hello_miopen

hipcc -D__HIP_PLATFORM_HCC__ -lrocsolver -lrocblas -L/opt/rocm/lib src/hello_rocsolver.cpp -o build/hello_rocsolver

./build/hello_rocsolver

