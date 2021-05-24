# check

[中文版](README_zh_CN.md)

Collect codes for check hip and rocm-libs

Execute `sh check.sh`, will display version information of components.

On gfx803, There is no `hipErrorNoBinaryForGpu` error, when just display version information.

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

Execute `sh run-rocrand.sh` will report `hipErrorNoBinaryForGpu`.

```
"hipErrorNoBinaryForGpu: Unable to find code object for all current devices!"
Aborted (core dumped)

```

Execute `sh run-miopen.sh` will report `hipErrorNoBinaryForGpu`.

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
