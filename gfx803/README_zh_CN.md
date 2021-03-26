
# ROCm-3.7及其以后版本，在gfx803系列显卡上有很多问题

[English Version](README.md)

更新时间: 2021-03-27

|软件           |备注   |
|---------------|--------------|
|OS             |Ubuntu-20.04.1|
|Python         |3.8.5         |
|Tensorflow-rocm|2.4.0         |

|硬件    |产品名称    |指令集           |芯片   |
|--------|------------|-----------------|-------|
|CPU     |Xeon 2620v3 |                 |       |
|GPU     |RX580 8G    |gfx803(Polaris10)|0x67df |

---

## 自ROCm-4.0开始，AMD不再提供对gfx803的官方支持

* 2020-12-19，gfx803被从ROCm-4.0的官方支持名单中删除
* <https://github.com/RadeonOpenCompute/ROCm/commit/2b7f806b106f2b19036bf8e7af4f3dad7bc6222e#diff-b335630551682c19a781afebcf4d07bf978fb1f8ac04c6bf87428ed5106870f5L408>

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

---

## ROCm-4.1版本下使用gfx803显卡会直接崩溃

### 问题描述

如果在gfx803显卡环境安装ROCm-4.1，会在执行tensorflow或pytorch时直接崩溃。
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
mkdir rocRAND/build
cd rocRAND/build

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

