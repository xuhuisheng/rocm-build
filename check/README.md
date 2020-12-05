# check

Collect codes for check rocm-libs

* rocBLAS
* rocFFT
* rocPRIM
* rocRAND
* rocSPARSE
* rccl
* MIOpen

Execute `sh check.sh`, will display version information of components.

On gfx803, rocSPARSE report `hipErrorNoBinaryForGpu`, so we know it has issues.

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
