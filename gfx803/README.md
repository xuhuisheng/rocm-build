
# So many gfx803 issues on ROCm-3.7+

[中文版](README_zh_CN.md)

Date: 2020-11-21

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

* **Workaround 1**: I rebuild rocBLAS with BUILD_WITH_TENSILE_HOST=false, and the problem dispeared, Maybe the gfx803 r9nano_*.yml is out-of-date? This way caused compiling failure on ROCm-3.9.
* **Workaround 2**: keep BUILD_WITH_TENSILE_HOST=true, delete library/src/blas3/Tensile/Logic/asm_full/r9nano_*_SB.yaml from rocBLAS, and issue resolved. If I just keep one solution of this file, issue reproduced.

---

## ROCm-3.9+ crashed with gfx803

### Description

If you installed ROCm-3.9+ with gfx803, you will crash on very beginning of running tensorflow or pytorch.
Error info as follows:

```
work@0b7758c3094d:~/test/examples/mnist$ python3 main.py
/src/external/hip-on-vdi/rocclr/hip_code_object.cpp:120: guarantee(false && "hipErrorNoBinaryForGpu: Coudn't find binary for current devices!")
Aborted (core dumped)
```

### Reason of problem

rocSPARSE placed CACHED AMDGPU_TARGETS after include Dependencies.cmake, so it is always skipped.
The AMDGPU_TARGETS from include Dependencies.cmake is "gfx900;gfx906;gfx908", not including gfx803.
So rocSPARSE didnot compile gfx803 binary image.

### Issue (closed)

<https://github.com/RadeonOpenCompute/ROCm/issues/1269>

### Pull request (merged)

<https://github.com/ROCmSoftwarePlatform/rocSPARSE/pull/213>

### Workaround

There are other issues on develop branch of rocSPARSE.
We have to switch to rocm-4.0.x branch then update CMakeLists.txt with the patch.
<https://github.com/ROCmSoftwarePlatform/rocSPARSE/commit/f8791e9b09c4ac6d72f56fb3c6663273dce2aea5#commitcomment-43334853>

The issue of develop branch fixed for gfx803 <https://github.com/ROCmSoftwarePlatform/rocSPARSE/commit/7de15942cf9fe0fb7db80e0c45ebb4d1e3086668>

If you want to compile rocSPARSE manually, can use my forked rocSPARSE repository, the patch had be commited to the default branch.

1. Install ROCm <https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html#ubuntu>
2. At least install rocm-dev and rocm-libs `sudo apt install rocm-dev rocm-libs`
3. `git clone https://github.com/xuhuisheng/rocSPARSE`
4. `cd rocSPARSE`
5. `bash install.sh -di`

---

