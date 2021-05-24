
# ROCm-3.7及其以后版本，在gfx803系列显卡上有很多问题

[English Version](README.md)

更新时间: 2021-05-24

|软件           |备注          |
|---------------|--------------|
|OS             |Ubuntu-20.04.2|
|Python         |3.8.5         |
|Tensorflow-rocm|2.4.3         |

|硬件    |产品名称    |指令集           |芯片   |
|--------|------------|-----------------|-------|
|CPU     |Xeon 2620v3 |                 |       |
|GPU     |RX580 8G    |gfx803(Polaris10)|0x67df |

---

## 自ROCm-4.0开始，AMD不再提供对gfx803的官方支持

* 2020-12-19，gfx803被从ROCm-4.0的官方支持名单中删除
* <https://github.com/RadeonOpenCompute/ROCm/commit/2b7f806b106f2b19036bf8e7af4f3dad7bc6222e#diff-b335630551682c19a781afebcf4d07bf978fb1f8ac04c6bf87428ed5106870f5L408>

不想自己编译ROCm，也可以降级到ROCm-3.5.1，这儿有一份文档<https://github.com/boriswinner/RX580-rocM-tensorflow-ubuntu20.4-guide>。

---

## ROCm-3.7及以后，使用gfx803系列显卡会遇到各种训练失败的问题

### 问题描述

* 在gfx803系列显卡环境安装ROCm-3.7或以后版本，运行tensorflow官方提供的文本分类示例，大概率90%能复现次此问题。<https://www.tensorflow.org/tutorials/keras/text_classification>
* 很多人都遇到了这个问题，可以参考官方网站 <https://github.com/RadeonOpenCompute/ROCm/issues/1265>

### 问题原因

* 还不清楚原因

### 关联问题

<https://github.com/ROCmSoftwarePlatform/rocBLAS/issues/1172>

### 解决方法

删除rocBLAS中的 library/src/blas3/Tensile/Logic/asm_full/r9nano_*.yaml ，重新编译rocBLAS，就能解决问题。即使只保留一个r9nano的文件也会重现问题。

```
git clone https://github.com/ROCmSoftwarePlatform/rocBLAS.git
cd rocBLAS
git checkout rocm-4.2.x

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

## ROCm-4.1或ROCm-4.2版本下使用gfx803显卡会直接崩溃

### 问题描述

如果在gfx803显卡环境安装ROCm-4.1或ROCm-4.2，会在执行tensorflow或pytorch时直接崩溃。
错误信息如下：

```
work@d70a3f3f5916:~/test/examples/mnist$ python main.py
"hipErrorNoBinaryForGpu: Unable to find code object for all current devices!"
Aborted (core dumped)

```

### 问题原因

rocRAND删除了AMDGPU_TARGETS中的gfx803。rocRAND就不会为gfx803编译对应的二进制了。

### 关联问题

-

### 关联补丁 (已合并)

* 已合并 <https://github.com/ROCmSoftwarePlatform/rocRAND/pull/170>
* 已关闭 <https://github.com/ROCmSoftwarePlatform/rocRAND/pull/159>

### 解决方法

使用AMDGPU_TARGETS=gfx803重新编译rocRAND

```
git clone https://github.com/ROCmSoftwarePlatform/rocRAND.git
cd rocRAND
git checkout rocm-4.2.x

bash install -d

mkdir build
cd build

CXX=/opt/rocm/hip/bin/hipcc cmake \
    -DAMDGPU_TARGETS="gfx803" \
    -DHIP_CLANG_INCLUDE_PATH=/opt/rocm/llvm/include \
    -DCMAKE_PREFIX_PATH="/opt/rocm/;/opt/rocm/llvm" \
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

---

## ROCm-4.2版本下使用gfx803显卡会直接崩溃

### Description

如果在gfx803显卡环境安装ROCm-4.2，会在执行pytorch时直接崩溃。
错误信息如下：

```
warning: xnack 'Off' was requested for a processor that does not support it!
warning: xnack 'Off' was requested for a processor that does not support it!
"hipErrorNoBinaryForGpu: Unable to find code object for all current devices!"
Aborted (core dumped)

```

### Reason of problem

对于xnack参数可以设置三个值On(启用), Off(关闭), Default(默认)。gfx803不支持xnack所以只能用default(默认)。
但是MIOpen只提供了On(启用), Off(关闭)两个选项。所以匹配失败。

### Issue

-

### Pull request

-

### Workaround

使用补丁重新编译MIOpen。
请参考`34.miopen.sh`。

---

## Pytorch-1.8.1在gfx803下崩溃

### 问题描述

pytorch官方网站提供了一个beta版的Pytorch-1.8.1。 
<https://pytorch.org/get-started/locally/>

一运行就会报错。

```
/data/jenkins_workspace/centos_pipeline_job_4.0/rocm-rel-4.0/rocm-4.0-26-20210119/7.7/external/hip-on-vdi/rocclr/hip_code_object.cpp:120: guarantee(false && "hipErrorNoBinaryForGpu: Coudn't find binary for current devices!") 

```

### 问题原因

官方pytorch-1.8.1没有提供gfx803二进制镜像。

### 关联问题

-

### 关联补丁

-

### 解决方法

使用PYTORCH_ROCM_ARCH=gfx803重新编译pytorch

```
sudo ln -f -s /usr/bin/python3 /usr/bin/python

git clone https://github.com/pytorch/pytorch
cd pytorch
git checkout v1.8.1
git submodule update --init --recursive

sudo apt install -y libopencv-highgui4.2 libopenblas-dev python3-dev python3-pip
pip3 install -r requirements.txt
export PATH=/opt/rocm/bin:$PATH \
    ROCM_PATH=/opt/rocm \
    HIP_PATH=/opt/rocm/hip 
export PYTORCH_ROCM_ARCH=gfx803
python3 tools/amd_build/build_amd.py
USE_ROCM=1 USE_NINJA=1 python3 setup.py bdist_wheel

pip3 install dist/torch-1.8.0a0+56b43f4-cp38-cp38-linux_x86_64.whl

```

