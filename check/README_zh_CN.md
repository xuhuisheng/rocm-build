# 检查代码

[English Version](README.md)

整理了一些用于检测rocm-libs的代码

* rocBLAS
* rocFFT
* rocPRIM
* rocRAND
* rocSPARSE
* rccl
* MIOpen

执行 `sh check.sh`，会显示各个组件的版本。

在gfx803显卡下，rocSPARSE会报错 `hipErrorNoBinaryForGpu`，我们就知道是它的问题了。

```
[rocBLAS]   2.32.0.2844-cc18d25f
[rocFFT]    1.0.8.966-rocm-rel-3.10-27-2d35fd6
[rocPRIM]   201005
[rocRAND]   201006
/src/external/hip-on-vdi/rocclr/hip_code_object.cpp:120: guarantee(false && "hipErrorNoBinaryForGpu: Coudn't find binary for current devices!")
Aborted (core dumped)
[rccl]      2708
[MIOpen]    2 9 0

```
