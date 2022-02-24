# 检查代码

[English Version](README.md)

整理了一些用于检测hip和rocm-libs的代码

执行 `sh check.sh`，会显示各个组件的版本。

在gfx803显卡下，只打印版本信息，不会报错`hipErrorNoBinaryForGpu`了。

```
[HIP]        50013601
[rocBLAS]    2.42.0.60c5f03d-dirty
[rocFFT]     1.0.15.fb0d3f8
[rocPRIM]    201009
[rocRAND]    201009
[rocSPARSE]  200000
[rccl]       21003
[MIOpen]     2 15 0
[rocSOVLER]  3.16.0.39ccf7a
[rocThrust]  101400
[rocALUTION] 20001
[hipCUB]     201012
[hipBLAS]    0 49 0
[hipSPARSE]  200000
[hipRAND]    201009
[hipFFT]     10015

```

