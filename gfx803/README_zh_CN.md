
# ROCm-3.7及其以后版本，在gfx803系列显卡上有很多问题

[English Version](README.md)

更新时间: 2022-02-24

|软件           |备注          |
|---------------|--------------|
|OS             |Ubuntu-20.04.3|
|Python         |3.8.10        |
|Tensorflow-rocm|2.4.3         |

|硬件    |产品名称    |指令集           |芯片   |
|--------|------------|-----------------|-------|
|CPU     |Xeon 2620v3 |                 |       |
|GPU     |RX580 8G    |gfx803(Polaris10)|0x67df |

---

使用ROCm-5.0，只需要给rocBLAS打一个补丁，就可以正常跑起来。

---

## 自ROCm-4.0开始，AMD不再提供对gfx803的官方支持

* 2020-12-19，gfx803被从ROCm-4.0的官方支持名单中删除
* <https://github.com/RadeonOpenCompute/ROCm/commit/2b7f806b106f2b19036bf8e7af4f3dad7bc6222e#diff-b335630551682c19a781afebcf4d07bf978fb1f8ac04c6bf87428ed5106870f5L408>

不想自己编译ROCm，也可以降级到ROCm-3.5.1，这儿有一份文档<https://github.com/boriswinner/RX580-rocM-tensorflow-ubuntu20.4-guide>。

---

## ROCm-3.7以及后续版本使用gfx803运行报错

### 问题描述

* ROCm-3.7以及后续版本使用gfx803都会报错，比如，运行tensorflow的文本分类实例。Tensorflow官方实例可以90%概率复现问题。 <https://www.tensorflow.org/tutorials/keras/text_classification>
* 其他用户也遇到了同类问题： <https://github.com/RadeonOpenCompute/ROCm/issues/1265>

### 问题原因

* 还不清楚

### 关联问题

<https://github.com/ROCmSoftwarePlatform/rocBLAS/issues/1172>

### 解决方法

删除rocBLAS的`library/src/blas3/Tensile/Logic/asm_full/r9nano_*.yaml`，重新编译rocBLAS。保留r9nano对应的任意一个文件都有可能重现问题。

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

## Pytorch-1.9.0在gfx803下崩溃

### 问题描述

pytorch官方网站提供了一个beta版的Pytorch-1.9.0。 
<https://pytorch.org/get-started/locally/>

一运行就会报错。

```
"hipErrorNoBinaryForGpu: Unable to find code object for all current devices!"

```

### 问题原因

官方pytorch-1.9.0没有提供gfx803二进制镜像。

### 关联问题

-

### 关联补丁

-

### 解决方法

(等待Pytorch-1.11.0支持ROCm-5.0。)

使用PYTORCH_ROCM_ARCH=gfx803重新编译pytorch。

Pytorch-1.9.0需要为ROCm-4.3打一个补丁，因为HIP的版本号修改了。

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

PS: 对应ROCm-4.2的pytorch-1.9.0会报错找不到 libtinfo.so.5 。

```
Traceback (most recent call last):
  File "test-pytorch-rocblas.py", line 4, in <module>
    import torch
  File "/home/work/.local/lib/python3.8/site-packages/torch/__init__.py", line 197, in <module>
    from torch._C import *  # noqa: F403
ImportError: libtinfo.so.5: cannot open shared object file: No such file or directory

```

为libtinfo.so创建一个软连接，因为当前tinfo的版本已经是6了，不是5了。

```
sudo ln -s /usr/lib/x86_64-linux-gnu/libtinfo.so /usr/lib/x86_64-linux-gnu/libtinfo.so.5

```



