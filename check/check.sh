#!/bin/bash

export PATH=/opt/rocm/bin:$PATH

hipcc -D__HIP_PLATFORM_HCC__ -lrocblas -L/opt/rocm/lib hello_rocblas.cpp -o hello_rocblas

./hello_rocblas

hipcc -D__HIP_PLATFORM_HCC__ -lrocfft -L/opt/rocm/lib hello_rocfft.cpp -o hello_rocfft

./hello_rocfft

hipcc -D__HIP_PLATFORM_HCC__ hello_rocprim.cpp -o hello_rocprim

./hello_rocprim

hipcc -D__HIP_PLATFORM_HCC__ -lrocrand -L/opt/rocm/lib hello_rocrand.cpp -o hello_rocrand

./hello_rocrand

hipcc -D__HIP_PLATFORM_HCC__ -lrocsparse -L/opt/rocm/lib hello_rocsparse.cpp -o hello_rocsparse

./hello_rocsparse

hipcc -D__HIP_PLATFORM_HCC__ -lrccl -L/opt/rocm/lib hello_rccl.cpp -o hello_rccl

./hello_rccl

hipcc -D__HIP_PLATFORM_HCC__ -lMIOpen -L/opt/rocm/lib hello_miopen.cpp -o hello_miopen

./hello_miopen

