#!/bin/bash

set -x

pushd .

source env.sh

#bash install-dependency.sh

#bash local/prepare-cmake.sh

#bash local/prepare-boost.sh

bash 00.rocm-core.sh

bash 11.rocm-llvm.sh

bash 12.roct-thunk-interface.sh

bash 13.rocm-cmake.sh

bash 14.rocm-device-libs.sh

bash 15.rocr-runtime.sh

bash 16.rocminfo.sh

bash 17.rocm-compilersupport.sh

bash 18.hip.sh

bash 21.rocfft.sh

bash local/22.rocblas.sh

bash 23.rocprim.sh

bash 24.rocrand.sh

bash 25.rocsparse.sh

bash 26.hipsparse.sh

bash 27.rocm_smi_lib.sh

bash 28.rccl.sh

bash 29.hipfft.sh

bash 31.rocm-opencl-runtime.sh

bash 32.clang-ocl.sh

bash 33.roctracer.sh

bash 34.half.sh

bash local/35.miopen.sh

bash 36.rocm-utils.sh

bash 41.rocprofiler.sh

bash 42.rocdbgapi.sh

# bash 43.rocgdb.sh

bash 44.rocm-dev.sh

bash 51.rocsolver.sh

bash 52.rocthrust.sh

bash 53.hipblas.sh

bash 54.rocalution.sh

bash 55.hipcub.sh

bash 56.hipsolver.sh

bash 57.rocm-libs.sh

# bash 61.amdmigraphx.sh

# bash 62.rock-dkms.sh

bash 71.rocm_bandwidth_test.sh

bash 72.hipfort.sh

bash 73.rocmvalidationsuite.sh

bash 74.rocr_debug_agent.sh

bash 75.hipify.sh

popd

