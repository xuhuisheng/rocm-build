#!/bin/bash

set -ex

mkdir -p build/rocm-ubuntu2204
cd build/rocm-ubuntu2204
pushd .

mkdir -p dists/jammy/main/binary-amd64
mkdir -p pool/main/{c,h,m,r}

cat > dists/jammy/main/binary-amd64/Release <<EOF
Origin: rocm-ubuntu2204
Label: rocm-ubuntu2204
Suite: jammy
Codename: jammy
Version: 5.2.0
Architectures: amd64
Components: main
Description: ROCm ubuntu2204 APT Repository
EOF

mkdir -p pool/main/c/comgr
cp $ROCM_BUILD_DIR/rocm-compilersupport/comgr_*.deb pool/main/c/comgr/

mkdir -p pool/main/h/half
cp $ROCM_BUILD_DIR/half/half_*.deb pool/main/h/half
mkdir -p pool/main/h/{hip-dev,hip-doc,hip-runtime-amd,hip-samples}
cp $ROCM_BUILD_DIR/hip/hip-dev_*.deb pool/main/h/hip-dev
cp $ROCM_BUILD_DIR/hip/hip-doc_*.deb pool/main/h/hip-doc
cp $ROCM_BUILD_DIR/hip/hip-runtime-amd_*.deb pool/main/h/hip-runtime-amd
cp $ROCM_BUILD_DIR/hip/hip-samples_*.deb pool/main/h/hip-samples
mkdir -p pool/main/h/{hipblas,hipblas-dev}
cp $ROCM_BUILD_DIR/hipblas/hipblas_*.deb pool/main/h/hipblas
cp $ROCM_BUILD_DIR/hipblas/hipblas-dev_*.deb pool/main/h/hipblas-dev
mkdir -p pool/main/h/hipcub-dev
cp $ROCM_BUILD_DIR/hipcub/hipcub-dev_*.deb pool/main/h/hipcub-dev
mkdir -p pool/main/h/{hipfft,hipfft-dev}
cp $ROCM_BUILD_DIR/hipfft/hipfft_*.deb pool/main/h/hipfft
cp $ROCM_BUILD_DIR/hipfft/hipfft-dev_*.deb pool/main/h/hipfft-dev
mkdir -p pool/main/h/{hipfort,hipfort-dev}
cp $ROCM_BUILD_DIR/hipfort/hipfort_*.deb pool/main/h/hipfort
cp $ROCM_BUILD_DIR/hipfort/hipfort-dev_*.deb pool/main/h/hipfort-dev
mkdir -p pool/main/h/hipify
cp $ROCM_BUILD_DIR/hipify/hipify-clang_*.deb pool/main/h/hipify
mkdir -p pool/main/h/{hipsolver,hipsolver-dev}
cp $ROCM_BUILD_DIR/hipsolver/hipsolver_*.deb pool/main/h/hipsolver
cp $ROCM_BUILD_DIR/hipsolver/hipsolver-dev_*.deb pool/main/h/hipsolver-dev
mkdir -p pool/main/h/{hipsparse,hipsparse-dev}
cp $ROCM_BUILD_DIR/hipsparse/hipsparse_*.deb pool/main/h/hipsparse
cp $ROCM_BUILD_DIR/hipsparse/hipsparse-dev_*.deb pool/main/h/hipsparse-dev
mkdir -p pool/main/h/{hsa-rocr,hsa-rocr-dev}
cp $ROCM_BUILD_DIR/rocr-runtime/hsa-rocr_*.deb pool/main/h/hsa-rocr
cp $ROCM_BUILD_DIR/rocr-runtime/hsa-rocr-dev_*.deb pool/main/h/hsa-rocr-dev
mkdir -p pool/main/h/hsakmt-roct-dev
cp $ROCM_BUILD_DIR/roct-thunk-interface/hsakmt-roct-dev_*.deb pool/main/h/hsakmt-roct-dev


mkdir -p pool/main/m/{miopen-hip,miopen-hip-dev}
cp $ROCM_BUILD_DIR/miopen/miopen-hip_*.deb pool/main/m/miopen-hip
cp $ROCM_BUILD_DIR/miopen/miopen-hip-dev_*.deb pool/main/m/miopen-hip-dev

mkdir -p pool/main/r/{rccl,rccl-dev}
cp $ROCM_BUILD_DIR/rccl/rccl_*.deb pool/main/r/rccl
cp $ROCM_BUILD_DIR/rccl/rccl-dev_*.deb pool/main/r/rccl-dev
mkdir -p pool/main/r/{rocalution,rocalution-dev}
cp $ROCM_BUILD_DIR/rocalution/rocalution_*.deb pool/main/r/rocalution
cp $ROCM_BUILD_DIR/rocalution/rocalution-dev_*.deb pool/main/r/rocalution-dev
mkdir -p pool/main/r/{rocblas,rocblas-dev}
cp $ROCM_BUILD_DIR/rocblas/rocblas_*.deb pool/main/r/rocblas
cp $ROCM_BUILD_DIR/rocblas/rocblas-dev_*.deb pool/main/r/rocblas-dev
mkdir -p pool/main/r/{rocfft,rocfft-dev}
cp $ROCM_BUILD_DIR/rocfft/rocfft_*.deb pool/main/r/rocfft
cp $ROCM_BUILD_DIR/rocfft/rocfft-dev_*.deb pool/main/r/rocfft-dev
mkdir -p pool/main/r/rocm-bandwidth-test
cp $ROCM_BUILD_DIR/rocm_bandwidth_test/rocm-bandwidth-test_*.deb pool/main/r/rocm-bandwidth-test
mkdir -p pool/main/r/rocm-clang-ocl
cp $ROCM_BUILD_DIR/clang-ocl/rocm-clang-ocl_*.deb pool/main/r/rocm-clang-ocl
mkdir -p pool/main/r/rocm-cmake
cp $ROCM_BUILD_DIR/rocm-cmake/rocm-cmake_*.deb pool/main/r/rocm-cmake
mkdir -p pool/main/r/rocm-core
cp $ROCM_BUILD_DIR/rocm-core/rocm-core_*.deb pool/main/r/rocm-core
mkdir -p pool/main/r/rocm-dbgapi
cp $ROCM_BUILD_DIR/rocdbgapi/rocm-dbgapi_*.deb pool/main/r/rocm-dbgapi
mkdir -p pool/main/r/rocm-debug-agent
cp $ROCM_BUILD_DIR/rocr_debug_agent/rocm-debug-agent_*.deb pool/main/r/rocm-debug-agent
mkdir -p pool/main/r/rocm-dev
cp $ROCM_BUILD_DIR/rocm-dev/rocm-dev_*.deb pool/main/r/rocm-dev
mkdir -p pool/main/r/rocm-device-libs
cp $ROCM_BUILD_DIR/rocm-device-libs/rocm-device-libs_*.deb pool/main/r/rocm-device-libs
mkdir -p pool/main/r/rocm-libs
cp $ROCM_BUILD_DIR/rocm-libs/rocm-libs_*.deb pool/main/r/rocm-libs
mkdir -p pool/main/r/rocm-llvm
cp $ROCM_BUILD_DIR/llvm-amdgpu/rocm-llvm_*.deb pool/main/r/rocm-llvm
mkdir -p pool/main/r/{rocm-ocl-icd,rocm-opencl,rocm-opencl-dev}
cp $ROCM_BUILD_DIR/rocm-opencl-runtime/rocm-ocl-icd_*.deb pool/main/r/rocm-ocl-icd
cp $ROCM_BUILD_DIR/rocm-opencl-runtime/rocm-opencl_*.deb pool/main/r/rocm-opencl
cp $ROCM_BUILD_DIR/rocm-opencl-runtime/rocm-opencl-dev_*.deb pool/main/r/rocm-opencl-dev
mkdir -p pool/main/r/rocm-smi-lib
cp $ROCM_BUILD_DIR/rocm_smi_lib/rocm-smi-lib_*.deb pool/main/r/rocm-smi-lib
mkdir -p pool/main/r/rocm-utils
cp $ROCM_BUILD_DIR/rocm-utils/rocm-utils_*.deb pool/main/r/rocm-utils
mkdir -p pool/main/r/rocm-validation-suite
cp $ROCM_BUILD_DIR/rocmvalidationsuite/rocm-validation-suite_*.deb pool/main/r/rocm-validation-suite
mkdir -p pool/main/r/rocminfo
cp $ROCM_BUILD_DIR/rocminfo/rocminfo_*.deb pool/main/r/rocminfo
mkdir -p pool/main/r/rocprim-dev
cp $ROCM_BUILD_DIR/rocprim/rocprim-dev_*.deb pool/main/r/rocprim-dev
mkdir -p pool/main/r/rocprofiler-dev
cp $ROCM_BUILD_DIR/rocprofiler/rocprofiler-dev_*.deb pool/main/r/rocprofiler-dev
mkdir -p pool/main/r/{rocrand,rocrand-dev}
cp $ROCM_BUILD_DIR/rocrand/rocrand_*.deb pool/main/r/rocrand
cp $ROCM_BUILD_DIR/rocrand/rocrand-dev_*.deb pool/main/r/rocrand-dev
mkdir -p pool/main/r/{rocsolver,rocsolver-dev}
cp $ROCM_BUILD_DIR/rocsolver/rocsolver_*.deb pool/main/r/rocsolver
cp $ROCM_BUILD_DIR/rocsolver/rocsolver-dev_*.deb pool/main/r/rocsolver-dev
mkdir -p pool/main/r/{rocsparse,rocsparse-dev}
cp $ROCM_BUILD_DIR/rocsparse/rocsparse_*.deb pool/main/r/rocsparse
cp $ROCM_BUILD_DIR/rocsparse/rocsparse-dev_*.deb pool/main/r/rocsparse-dev
mkdir -p pool/main/r/rocthrust-dev
cp $ROCM_BUILD_DIR/rocthrust/rocthrust-dev_*.deb pool/main/r/rocthrust-dev
mkdir -p pool/main/r/roctracer-dev
cp $ROCM_BUILD_DIR/roctracer/roctracer-dev_*.deb pool/main/r/roctracer-dev

dpkg-scanpackages -m . > dists/jammy/main/binary-amd64/Packages

cd dists/jammy

apt-ftparchive release . > Release

# gpg --armor --detach-sign --sign -o Release.gpg Release

# gpg --clearsign -o InRelease Release

popd

