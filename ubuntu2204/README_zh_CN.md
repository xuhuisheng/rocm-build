
# ubuntu-22.04补丁

[English](README.md)

时间: 2022-06-26

|软件           |描述          |
|---------------|--------------|
|OS             |Ubuntu-20.04.4|
|Python         |3.8.10        |
|ROCm           |5.1.3         |

|硬件    |产品        |ISA              |CHIP IP|
|--------|------------|-----------------|-------|
|CPU     |Xeon 2620v3 |                 |       |
|GPU     |RX580 8G    |gfx803(Polaris10)|0x67df |

---

ROCm-5.1.3 无法安装在ubuntu-22.04。需要一些补丁。
一些补丁来自ROCm-5.2的开发分支。

主要区别部分:

* gcc-11
* python-3.10
* fmt-8

## 18.hip

* 注释thread头文件。不知道为啥会导致miopen的native_conv.cpp报错
* 注释complex, new头文件。不知道为啥会导致miopen的native_conv.cpp报错

## 23.rocprim

* 增加thread头文件。对应hip的修改

## 33.roctracer

* 把pthread_yield替换为sched_yield，因为更严格的检查

## 51.rocsolver

* 对fmt8更新 <https://github.com/ROCmSoftwarePlatform/rocSOLVER/commit/2bbfb8976f6e4d667499c77e41a6433850063e88>

## 73.rocmvalidationsuite

* 升级googletest 1.11.0 <https://github.com/ROCm-Developer-Tools/ROCmValidationSuite/pull/543>

---

miopen依赖boost-1.72.0. 需要删除 `PTHREAD_STACK_MIN` 相关的代码，在 `boost/thread/pthread/thread_data.hpp`中

---

tensorflow中的breakpad报错 `max(int, long int)` 相关的类型转换错误。

---

pytorch 需要使用 `USE_ROCM=1 USE_NUMPY=1 ROCM_VERSION=50103 python3 setup.py bdist_wheel` 编译。

