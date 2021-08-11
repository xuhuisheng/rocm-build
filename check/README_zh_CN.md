# 检查代码

[English Version](README.md)

整理了一些用于检测hip和rocm-libs的代码

执行 `sh check.sh`，会显示各个组件的版本。

在gfx803显卡下，只打印版本信息，不会报错`hipErrorNoBinaryForGpu`了。

```
[HIP]        40321300
[rocBLAS]    2.39.0.8328dcce-dirty
[rocFFT]     1.0.12.b93c40c
[rocPRIM]    201009
[rocRAND]    201009
[rocSPARSE]  102002
[rccl]       2804
[MIOpen]     2 12 0
[rocSOVLER]  3.13.0.313bfc2
[rocThrust]  101100
[rocALUTION] 11201
[hipCUB]     201009
[hipBLAS]    0 46 0
[hipSPARSE]  101007
[hipRAND]    201009
[hipFFT]     10012

```

