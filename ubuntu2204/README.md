
# Patches for ubuntu-22.04

[中文版](README_zh_CN.md)

Date: 2022-06-26

|software       |description   |
|---------------|--------------|
|OS             |Ubuntu-20.04.4|
|Python         |3.8.10        |
|ROCm           |5.1.3         |

|hardware|Product Name|ISA              |CHIP IP|
|--------|------------|-----------------|-------|
|CPU     |Xeon 2620v3 |                 |       |
|GPU     |RX580 8G    |gfx803(Polaris10)|0x67df |

---

ROCm-5.1.3 cannot install properly on ubuntu-22.04. We need some patches.
Some patches comes from ROCm-5.2 develop branch.

The main different parts.

* gcc-11
* python-3.10
* fmt-8

## 18.hip

* comment out thread header. No idea why this caused miopen native_conv.cpp error
* comment out complex, new header. No idea why this caused miopen native_conv.cpp error

## 23.rocprim

* add thread header. because of hip modification

## 33.roctracer

* replace pthread_yield to sched_yield for strict check

## 51.rocsolver

* update for fmt8 <https://github.com/ROCmSoftwarePlatform/rocSOLVER/commit/2bbfb8976f6e4d667499c77e41a6433850063e88>

## 73.rocmvalidationsuite

* upgrade googletest 1.11.0 <https://github.com/ROCm-Developer-Tools/ROCmValidationSuite/pull/543>

---

miopen depends boost-1.72.0. We need remove `PTHREAD_STACK_MIN` related lines from `boost/thread/pthread/thread_data.hpp`

---

The breakpad from tensorflow throw a compiling error about `max(int, long int)` type cast.

---

The pytorch need compile with `USE_ROCM=1 USE_NUMPY=1 ROCM_VERSION=50103 python3 setup.py bdist_wheel`

