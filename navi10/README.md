# navi10

This is experimental scripts for building navi10 GPU, aka RX5700XT.

This is NOT the offical supporting codes, so I cannot guarantee RX5700XT could run successfully on ROCm, even compiling success.

No, I didnot have a navi10 GPU yet, So I cannot test it. Currently I can just confirm there is no compiling problems. Anybody who had navi10 GPU can have a try. Appreciate for any feedback.

---

The codes based on ROCm-3.10.0, please refer <../README.md> for preparing build environment.

OK. One thing must say before that building ROCm will cost lots of time, and huge memory. If your memory less then 32G, please using swap to prevent compiling error.
This caused compiling lower, but it wont break.

---

Now we can start our experiment.

First, install rocm-dev. This part already supports navi10, so we neednot re-compiling them. Since llvm-project may cost hours for compiling.

Then clone rocm-build to your local PC. Switch to develop branch.

```
git clone https://github.com/xuhuisheng/rocm-build
cd rocm-build
git checkout navi10

```

Modify <../env.sh>, find `AMDGPU_TARGETS`, change it to `AMDGPU_TARGETS="gfx1010"`, gfx1010 means navi10, RX5700XT. RX5500 related gfx1012.

1. execute `bash 21.rocfft.sh` to compile rocFFT.
2. 
3. execute `bash 23.rocprim.sh` to compile rocPRIM.
4. execute `bash 24.rocrand.sh` to compile rocRAND.
5. execute `bash navi10/25.rocsparse.sh` to compile rocSPARSE, there will use a patch for prevent copmiling problems.
6. execute `bash 26.hipsparse.sh` to compile hipSPARSE.
7. execute `bash 27.rccl.sh` to compile rccl.
8. execute `bash 34.miopen.sh` to compile MIOpen.
