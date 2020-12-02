# navi10

This is experimental scripts for building navi10 GPU, aka RX5700XT.

**This is NOT the offical supporting, Cannot guarantee RX5700XT could run successfully on ROCm, even compiling success.**

No, I didnot have a navi10 GPU yet, So I cannot test it. Currently I can just confirm there is no compiling problems. Anybody who had navi10 GPU can have a try. Appreciate for any feedback.

---

The codes based on ROCm-3.10.0, please refer <https://github.com/xuhuisheng/rocm-build/blob/navi10/README.md> for preparing build environment.

OK. One thing must say before that building ROCm will cost lots of time, and huge memory. If your memory less then 32G, please using swap to prevent compiling error.
This caused compiling even more slower, but it wont break.

---

Now we can start our experiment.

First, install `rocm-dev`. This part already supports navi10, so we neednot re-compiling them. Since llvm-project may cost hours for compiling.

Then clone `rocm-build` to your local. Switch to `navi10` branch.
For Example, we clone rocm-build to `/home/work/rocm-build`

```
cd /home/work

git clone https://github.com/xuhuisheng/rocm-build
cd rocm-build
git checkout navi10

```

Modify <https://github.com/xuhuisheng/rocm-build/blob/navi10/env.sh>, find `AMDGPU_TARGETS`, change it to `AMDGPU_TARGETS="gfx1010"`, gfx1010 means navi10, RX5700XT. RX5500 related gfx1012.
It will force ROCm to compile for navi10, even there is no matching hardware. Execute `source env.sh` to initialize environment variables.

The rocBLAS is a little complex, it depends Tensile. We need clone Tensile to local, switch to `rocm-3.10.0` tag, and use a patch.
For Example, we clone Tensile to `/home/work/Tensile`

```
cd /home/work

git clone https://github.com/ROCmSoftwarePlatform/Tensile
cd Tensile
git checkout rocm-3.10.0

```

Then execute `bash navi10/22.rocblas.sh` to compile rocBLAS. (Very slow)

1. execute `bash 21.rocfft.sh` to compile rocFFT. (Extremely slow)
2. execute `bash 23.rocprim.sh` to compile rocPRIM. (Very fast)
3. execute `bash 24.rocrand.sh` to compile rocRAND. (Fast)
4. execute `bash navi10/25.rocsparse.sh` to compile rocSPARSE, there will use a patch for prevent compiling problems. (Slow)
5. execute `bash 26.hipsparse.sh` to compile hipSPARSE. (Fast)
6. execute `bash 27.rccl.sh` to compile rccl. (Slow)
7. execute `bash 34.miopen.sh` to compile MIOpen. (Slow)

