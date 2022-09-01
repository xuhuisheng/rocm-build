# navi14

[中文版](README_zh_CN.md)

Please test override hsa version first.
Then ROCm will use gfx1030 fatbin to run on gfx1012, which needn't re-compile.

```
export HSA_OVERRIDE_GFX_VERSION=10.3.0
```

This is experimental scripts for building navi14 GPU, aka RX5500.

**This is NOT offical supporting, Cannot guarantee RX5500 could run successfully on ROCm, even compiling success.**

No, I didnot have a navi14 GPU yet, So I cannot test it. Currently I can just confirm there is no compiling problems. Anybody who had navi14 GPU can have a try. Appreciate for any feedback.

---

The codes based on ROCm-5.2.0, please refer <https://github.com/xuhuisheng/rocm-build/blob/master/README.md> for preparing build environment. OS is Ubuntu-20.04.4.

OK. One thing must clarify that building ROCm will cost lots of time, and huge memory. If your memory less then 32G, please using swap to prevent Out-Of-Memory.
This caused compiling even more slower, but it wont break.

---

Now we can start our experiment.

Please follow ROCm official installation guide for installing related dependenies libraries. <https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html#ubuntu>

First, install `rocm-dev`. This part already supports navi14, so we neednot re-compiling them. Since llvm-project may cost hours for compiling.

Then clone `rocm-build`. Switch to `master` branch.
For Example, we clone rocm-build to `/home/work/rocm-build`

```
cd /home/work

git clone https://github.com/xuhuisheng/rocm-build
cd rocm-build
git checkout master

source env.sh

```

Modify `env.sh`, find `AMDGPU_TARGETS`, change it to `AMDGPU_TARGETS="gfx1012"`, gfx1012 means navi14, RX5500XT.
It will force ROCm to compile for navi14, even there is no matching hardware. Execute `source env.sh` to initialize environment variables.

The rocBLAS is a little complex, it depends Tensile. Tensile had already included in ROCm source repo. We need use a patch.
For Example, ROCm source repo path is `/home/work/ROCm/`

Then execute `bash navi14/22.rocblas.sh` to compile rocBLAS, there will use a patch for prevent compiling problems. (Very slow)

Please make sure `Tensile_TEST_LOCAL_PATH` in `navi14/22.rocblas.sh` matches `Tensile` directory.

Other components is more simple, just execute the script to compile and install.
Beside rocBLAS, We need 4 more components to re-build for navi14.

1. execute `bash 21.rocfft.sh` to compile rocFFT. (Extremely slow)
2. execute `bash 24.rocrand.sh` to compile rocRAND. (Fast)
3. execute `bash navi14/25.rocsparse.sh` to compile rocSPARSE, there will use a patch for prevent compiling problems. (Slow)
4. execute `bash 27.rccl.sh` to compile rccl. (Slow)

Final step is Pytorch-1.12.0 (Extremely Slow)

```
sudo ln -f -s /usr/bin/python3 /usr/bin/python

git clone https://github.com/ROCmSoftwarePlatform/pytorch
cd pytorch
git checkout release/1.12
git submodule update --init --recursive

sudo apt install -y libopencv-highgui-dev libopenblas-dev python3-dev python3-pip cmake ninja-build git
pip3 install -r requirements.txt
export PATH=/opt/rocm/bin:$PATH \
    ROCM_PATH=/opt/rocm \
    HIP_PATH=/opt/rocm/hip 
export PYTORCH_ROCM_ARCH=gfx1012
python3 tools/amd_build/build_amd.py
USE_ROCM=1 USE_NINJA=1 python3 setup.py bdist_wheel

pip3 install dist/torch-1.12.0a0+git67ece03-cp38-cp38-linux_x86_64.whl

```

Finally we got a pytorch-1.12.0 only can run on navi14.

