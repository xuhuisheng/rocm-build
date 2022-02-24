
# So many gfx803 issues on ROCm-3.7+

[中文版](README_zh_CN.md)

Date: 2022-02-24

|software       |description   |
|---------------|--------------|
|OS             |Ubuntu-20.04.3|
|Python         |3.8.10        |
|Tensorflow-rocm|2.4.3         |

|hardware|Product Name|ISA              |CHIP IP|
|--------|------------|-----------------|-------|
|CPU     |Xeon 2620v3 |                 |       |
|GPU     |RX580 8G    |gfx803(Polaris10)|0x67df |

---

On ROCm-4.5, we only need patch rocBLAS and gfx803 can run properly.

---

## AMD drop gfx803 offical support on ROCm-4.0

* gfx803 had been removed from ROCm-4.0 offical supporting list on 2020-12-19
* <https://github.com/RadeonOpenCompute/ROCm/commit/2b7f806b106f2b19036bf8e7af4f3dad7bc6222e#diff-b335630551682c19a781afebcf4d07bf978fb1f8ac04c6bf87428ed5106870f5L408>

If you don't want to compile ROCm components from sources.
You can downgrade to ROCm-3.5.1, here is the documents <https://github.com/boriswinner/RX580-rocM-tensorflow-ubuntu20.4-guide>.

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

Delete `library/src/blas3/Tensile/Logic/asm_full/r9nano_*.yaml` from rocBLAS, rebuild rocBLAS, issue resolved. If I just keep one solution of this file, issue reproduced.

```
git clone https://github.com/ROCmSoftwarePlatform/rocBLAS.git
cd rocBLAS
git checkout release/rocm-rel-5.0

bash install.sh -d

rm -rf library/src/blas3/Tensile/Logic/asm_full/r9nano*

mkdir build
cd build

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

## Pytorch-1.9.0 crashed on gfx803

### Description

There is a beta version Pytorch-1.9.0 on pytorch offical website. 
<https://pytorch.org/get-started/locally/>

And it will crash on very beginning of running pytorch.
Error info as follows:

```
"hipErrorNoBinaryForGpu: Unable to find code object for all current devices!"

```

### Reason of problem

Offical pytorch-1.9.0 didn't provide fatbin for gfx803.

### Issue

-

### Pull request

-

### Workaround

(Waiting for Pytorch-1.11.0 to support ROCm-5.0.)

Rebuild Pytorch with PYTORCH_ROCM_ARCH=gfx803.

Pytorch-1.9.0 need do a patch for ROCm-4.3 HIP version updating.

```
sudo ln -f -s /usr/bin/python3 /usr/bin/python

git clone https://github.com/pytorch/pytorch
cd pytorch
git checkout v1.9.0
git submodule update --init --recursive

git apply /home/work/rocm-build/patch/pytorch-rocm43-1.patch

sudo apt install -y libopencv-highgui4.2 libopenblas-dev python3-dev python3-pip
pip3 install -r requirements.txt
export PATH=/opt/rocm/bin:$PATH \
    ROCM_PATH=/opt/rocm \
    HIP_PATH=/opt/rocm/hip 
export PYTORCH_ROCM_ARCH=gfx803
python3 tools/amd_build/build_amd.py
USE_ROCM=1 USE_NINJA=1 python3 setup.py bdist_wheel

pip3 install dist/torch-1.9.0a0+gitd69c22d-cp38-cp38-linux_x86_64.whl

```

PS: The pytorch-1.9.0 for ROCm-4.2 report cannot find libtinfo.so.5.

```
Traceback (most recent call last):
  File "test-pytorch-rocblas.py", line 4, in <module>
    import torch
  File "/home/work/.local/lib/python3.8/site-packages/torch/__init__.py", line 197, in <module>
    from torch._C import *  # noqa: F403
ImportError: libtinfo.so.5: cannot open shared object file: No such file or directory

```

Create a symblic link for libtinfo.so, the current version of tinfo is 6, not 5.

```
sudo ln -s /usr/lib/x86_64-linux-gnu/libtinfo.so /usr/lib/x86_64-linux-gnu/libtinfo.so.5

```

