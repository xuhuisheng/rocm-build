
# ROCm-3.7及其以后版本，在gfx803系列显卡上有很多问题

[English Version](README.md)

创建时间: 2020-11-21

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

* **方法 1**: 使用BUILD_WITH_TENSILE_HOST=false参数重新编译rocBLAS，可能因为gfx803对应的r9nano_*.yml这些配置文件有问题。方法1在ROCm-3.9及之后会导致编译失败。
* **方法 2**: 保持BUILD_WITH_TENSILE_HOST=true不变，删除rocBLAS项目下library/src/blas3/Tensile/Logic/asm_full/r9nano_*_SB.yaml所有对应文件，重新编译。如果保留任何一个文件都会复现此问题。

---

## ROCm-3.9及以后，使用gfx803系列显卡会直接崩溃

### 问题描述

如果在gfx803系列显卡环境下安装ROCm-3.9或以后版本，运行tensorflow或pytorch会直接崩溃。
错误信息如下：

```
work@0b7758c3094d:~/test/examples/mnist$ python3 main.py
/src/external/hip-on-vdi/rocclr/hip_code_object.cpp:120: guarantee(false && "hipErrorNoBinaryForGpu: Coudn't find binary for current devices!")
Aborted (core dumped)
```

### 问题原因

rocSPARSE的CMakeLists.txt配置文件里，把AMDGPU_TARGETS放到了Dependencies.cmake后面，因为AMDGPU_TARGETS配置为缓存参数，它会一直被覆盖，所以不会生效。
而Dependencies.cmake中配置的AMDGPU_TARGETS参数为"gfx900;gfx906;gfx908"，这会导致编译出的二进制文件不支持gfx803。

### 关联问题 (已关闭)

<https://github.com/RadeonOpenCompute/ROCm/issues/1269>

### 关联补丁 (已合并)

<https://github.com/ROCmSoftwarePlatform/rocSPARSE/pull/213>

### 解决方法

因为rocSPARSE的开发分支太新了，为了避免兼容问题，建议使用rocm-4.0.x分支，再对CMakeLists.txt打补丁，
其实就是把AMDGPU_TARGETS放到Dependencies.cmake前面，避免被覆盖。

我把rocSPARSE复制了一份，已经把gfx803的补丁打到了默认分支上，可以直接使用。

1. 首先安装 <https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html#ubuntu>
2. 至少要安装 rocm-dev 和 rocm-libs `sudo apt install rocm-dev rocm-libs`
3. `git clone https://github.com/xuhuisheng/rocSPARSE`
4. `cd rocSPARSE`
5. `bash install.sh -di`

---

