# 检查代码

[English Version](README.md)

整理了一些用于检测hip和rocm-libs的代码

执行 `sh check.sh`，会显示各个组件的版本。

在gfx803显卡下，只打印版本信息，不会报错`hipErrorNoBinaryForGpu`了。

```
[HIP]        402
[rocBLAS]    2.38.0.
[rocFFT]     1.0.11.
[rocPRIM]    201009
[rocRAND]    201009
[rocSPARSE]  101905
[rccl]       2804
[MIOpen]     2 11 0
[rocSOVLER]  3.12.0.
[rocThrust]  101000
[rocALUTION] 11105
[hipCUB]     201009
[hipBLAS]    0 44 0
[hipSPARSE]  101006
[hipRAND]    201009
[hipFFT]     100

```

执行`sh run-rocrand.sh`会报错`hipErrorNoBinaryForGpu`。

```
"hipErrorNoBinaryForGpu: Unable to find code object for all current devices!"
Aborted (core dumped)

```

执行`sh run-miopen.sh`会报错`hipErrorNoBinaryForGpu`。

```
MIOPEN_VERSION_MAJOR:2
MIOPEN_VERSION_MINOR:11
MIOPEN_VERSION_PATCH:0
ws_size = 576
find conv algo
warning: xnack 'Off' was requested for a processor that does not support it!
warning: xnack 'Off' was requested for a processor that does not support it!
"hipErrorNoBinaryForGpu: Unable to find code object for all current devices!"
Aborted (core dumped)

```
