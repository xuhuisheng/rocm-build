
# So many gfx803 issues on ROCm-3.7+

[中文版](README_zh_CN.md)

Date: 2021-03-27

|software       |description   |
|---------------|--------------|
|OS             |Ubuntu-20.04.1|
|Python         |3.8.5         |
|Tensorflow-rocm|2.4.0         |

|hardware|Product Name|ISA              |CHIP IP|
|--------|------------|-----------------|-------|
|CPU     |Xeon 2620v3 |                 |       |
|GPU     |RX580 8G    |gfx803(Polaris10)|0x67df |

---

## AMD drop gfx803 offical support on ROCm-4.0

* gfx803 had been removed from ROCm-4.0 offical supporting list on 2020-12-19
* <https://github.com/RadeonOpenCompute/ROCm/commit/2b7f806b106f2b19036bf8e7af4f3dad7bc6222e#diff-b335630551682c19a781afebcf4d07bf978fb1f8ac04c6bf87428ed5106870f5L408>

---

## ROCm-3.7+ broke on gfx803

### Description

* ROCm-3.7+ on gfx803, run tensorflow text classification sample. Tensorflow offical sample could reproduce this issue, almost 90%. <https://www.tensorflow.org/tutorials/keras/text_classification>
* There are many people get this error, please refer here : <https://github.com/RadeonOpenCompute/ROCm/issues/1265>

### Reason of problem

* Dont know yet

### Issue

<https://github.com/ROCmSoftwarePlatform/rocBLAS/issues/1172>

### Workaround

Delete library/src/blas3/Tensile/Logic/asm_full/r9nano_*.yaml from rocBLAS, rebuild rocBLAS, issue resolved. If I just keep one solution of this file, issue reproduced.

```
git clone https://github.com/ROCmSoftwarePlatform/rocBLAS.git
cd rocBLAS
git checkout rocm-4.1.x

bash install.sh -d

rm -rf library/src/blas3/Tensile/Logic/asm_full/r9nano*

mkdir build
cd build

export CPACK_DEBIAN_PACKAGE_RELEASE=93c82939
export CPACK_RPM_PACKAGE_RELEASE=93c82939

CXX=/opt/rocm/bin/hipcc cmake -lpthread \
    -DAMDGPU_TARGETS=gfx803 \
    -DROCM_PATH=/opt/rocm \
    -DTensile_LOGIC=asm_full \
    -DTensile_ARCHITECTURE=all \
    -DTensile_CODE_OBJECT_VERSION=V3 \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_WITH_TENSILE_HOST=ON \
    -DTensile_LIBRARY_FORMAT=yaml \
    -DRUN_HEADER_TESTING=OFF \
    -DTensile_COMPILER=hipcc \
    -DHIP_CLANG_INCLUDE_PATH=/opt/rocm/llvm/include \
    -DCPACK_SET_DESTDIR=OFF \
    -DCMAKE_PREFIX_PATH=/opt/rocm \
    -DCMAKE_INSTALL_PREFIX=rocblas-install \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm \
    -DCPACK_GENERATOR=DEB \
    -G "Unix Makefiles" \
    ..

make -j
make package
sudo dpkg -i *.deb

```

---

## ROCm-4.1 crashed with gfx803

### Description

If you installed ROCm-4.1 with gfx803, you will crash on very beginning of running tensorflow or pytorch.
Error info as follows:

```
work@d70a3f3f5916:~/test/examples/mnist$ python main.py
"hipErrorNoBinaryForGpu: Unable to find code object for all current devices!"
Aborted (core dumped)

```

### Reason of problem

The rocRAND removed gfx803 from AMDGPU_TARGETS. So rocRAND didnot compile gfx803 binary image.

### Issue (closed)

-

### Pull request (merged)

* merged <https://github.com/ROCmSoftwarePlatform/rocRAND/pull/170>
* closed <https://github.com/ROCmSoftwarePlatform/rocRAND/pull/159>

### Workaround

Rebuild rocRAND with AMDGPU_TARGETS=gfx803

```
git clone https://github.com/ROCmSoftwarePlatform/rocRAND.git
cd rocRAND
git checkout rocm-4.1.x

bash install -d

mkdir build
cd build

CXX=/opt/rocm/hip/bin/hipcc cmake \
    -DAMDGPU_TARGETS="gfx803" \
    -DHIP_CLANG_INCLUDE_PATH=/opt/rocm/llvm/include \
    -DCMAKE_PREFIX_PATH="/opt/rocm/;/opt/rocm/llvm \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_SET_DESTDIR=OFF \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm \
    -G "Unix Makefiles" \
    ..
make -j
make package
sudo dpkg -i *.deb

```

