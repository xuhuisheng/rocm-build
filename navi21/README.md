# navi21

[中文版](README_zh_CN.md)

This is experimental scripts for building navi21 GPU, aka RX6800.

**This is NOT offical supporting, Cannot guarantee RX6800 could run successfully on ROCm, even compiling success.**

No, I didnot have a navi21 GPU yet, So I cannot test it. Currently I can just confirm there is no compiling problems. Anybody who had navi21 GPU can have a try. Appreciate for any feedback.

---

The codes based on ROCm-4.2.0, please refer <https://github.com/xuhuisheng/rocm-build/blob/master/README.md> for preparing build environment. OS is Ubuntu-20.04.2.

OK. One thing must clarify that building ROCm will cost lots of time, and huge memory. If your memory less then 32G, please using swap to prevent Out-Of-Memory.
This caused compiling even more slower, but it wont break.

---

Now we can start our experiment.

Please follow ROCm official installation guide for installing related dependenies libraries. <https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html#ubuntu>

First, install `rocm-dev`. This part already supports navi21, so we neednot re-compiling them. Since llvm-project may cost hours for compiling.

Then clone `rocm-build`. Switch to `master` branch.
For Example, we clone rocm-build to `/home/work/rocm-build`

```
cd /home/work

git clone https://github.com/xuhuisheng/rocm-build
cd rocm-build
git checkout master

source env.sh

```

Modify `env.sh`, find `AMDGPU_TARGETS`, change it to `AMDGPU_TARGETS="gfx1030"`, gfx1030 means navi21, RX6800.
It will force ROCm to compile for navi21, even there is no matching hardware. Execute `source env.sh` to initialize environment variables.

The rocBLAS is a little complex, it depends Tensile. Tensile had already included in ROCm source repo. We need use a patch.
For Example, ROCm source repo path is `/home/work/ROCm/`

Then execute `bash navi21/22.rocblas.sh` to compile rocBLAS, there will use a patch for prevent compiling problems. (Very slow)

Please make sure `Tensile_TEST_LOCAL_PATH` in `navi21/22.rocblas.sh` matches `Tensile` directory.

Other components is more simple, just execute the script to compile and install.

1. execute `bash 21.rocfft.sh` to compile rocFFT. (Extremely slow)
2. execute `bash 23.rocprim.sh` to compile rocPRIM. (Very fast)
3. execute `bash 24.rocrand.sh` to compile rocRAND. (Fast)
4. execute `bash navi21/25.rocsparse.sh` to compile rocSPARSE, there will use a patch for prevent compiling problems. (Slow)
5. execute `bash 26.hipsparse.sh` to compile hipSPARSE. (Fast)
6. execute `bash 27.rccl.sh` to compile rccl. (Slow)
7. execute `bash 34.miopen.sh` to compile MIOpen. (Slow)
8. execute `bash 52.rocthrust.sh` to compile rocThrust. (Very fast)
9. execute `bash 55.hipcub.sh` to compile hipCUB. (Very fast)

Final step is Pytorch-1.8.1 (Extremely Slow)

```
sudo ln -f -s /usr/bin/python3 /usr/bin/python

git clone https://github.com/pytorch/pytorch
cd pytorch
git checkout v1.8.1
git submodule update --init --recursive

sudo apt install -y libopencv-highgui4.2 libopenblas-dev python3-dev python3-pip
pip3 install -r requirements.txt
export PATH=/opt/rocm/bin:$PATH \
    ROCM_PATH=/opt/rocm \
    HIP_PATH=/opt/rocm/hip 
export PYTORCH_ROCM_ARCH=gfx1030
python3 tools/amd_build/build_amd.py
USE_ROCM=1 USE_NINJA=1 python3 setup.py bdist_wheel

pip3 install dist/torch-1.8.0a0+56b43f4-cp38-cp38-linux_x86_64.whl

```

Finally we got a pytorch-1.8.1 only can run on navi21.

Again, no GPU to test. At least there is no compile errors. Any feedback will be appreciate.

---

It is high possibility that ROCm can train full connection layer successfully, while failed on convolution layer.
Just like navi10. <https://github.com/RadeonOpenCompute/ROCm/issues/1306#issuecomment-751414407>
