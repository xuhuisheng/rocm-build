# navi10

[English Version](README.md)

这里是针对navi10 GPU - RX5700XT的实验性构建脚本。

**AMD官方还不支持navi10，就算编译成功也无法保证ROCm能支持RX5700XT。**

我也没有navi10 GPU，本地无法测试。目前只能确认没有编译错误。如果你有navi10 GPU可以尝试一下。欢迎各种反馈。

---

代码基于 ROCm-4.3.0，请参考 <https://github.com/xuhuisheng/rocm-build/blob/master/README_zh_CN.md> 准备构建环境，OS是 Ubuntu-20.04.2。

提前说一句，构建ROCm很花时间，而且需要大内存。如果内存小于32G，建议使用swap交换内存，避免内存不足。
虽然swap交换内存会让构建花费更长时间，但是至少不会崩。

---

现在可以开始实验了。

首先按照ROCm官方文档准备环境。<https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html#ubuntu>

首先安装`rocm-dev`。这部分已经支持navi10了，不用重新编译。主要也是因为llvm-project编译太慢，可能要花几个小时。

然后获取`rocm-build`。切换到`master`分支。
比如，我们把rocm-build放在`/home/work/rocm-build`目录下。

```
cd /home/work

git clone https://github.com/xuhuisheng/rocm-build
cd rocm-build
git checkout master

source env.sh

```

修改`env.sh`，找到`AMDGPU_TARGETS`，改为`AMDGPU_TARGETS="gfx1010"`，gfx1010对应navi10，RX5700XT。
我们强制ROCm对navi10进行编译，这一步不需要实际的硬件。执行`source env.sh`初始化环境变量。

首先编译rocBLAS，因为它有一点儿复杂，因为它依赖另一个名叫Tensile项目。Tensile已经包含在ROCm的repo源码里，我们需要打一个补丁。
比如，ROCm使用repo将源码复制到`/home/work/ROCm`目录下。

然后执行`bash navi10/22.rocblas.sh`编译rocBLAS，脚本里会自动打好补丁。（非常慢）

要确认`navi10/22.rocblas.sh`里的`Tensile_TEST_LOCAL_PATH`与Tensile的目录位置一致。

其他组件就比较简单了。直接执行脚本进行编译和安装。

1. 执行 `bash 21.rocfft.sh` 编译 rocFFT。 (超级超级慢)
2. 执行 `bash 23.rocprim.sh` 编译 rocPRIM。 (飞快)
3. 执行 `bash 24.rocrand.sh` 编译 rocRAND。 (很快)
4. 执行 `bash navi10/25.rocsparse.sh` 编译 rocSPARSE，需要打个补丁。(很慢)
5. 执行 `bash 26.hipsparse.sh` 编译 hipSPARSE。 (很快)
6. 执行 `bash 27.rccl.sh` 编译 rccl. (很慢)
7. 执行 `bash 28.hipfft.sh` 编译 hipfft. (飞快)
8. 执行 `bash 34.miopen.sh` 编译 MIOpen。 (很慢)
9. 执行 `bash 52.rocthrust.sh` 编译 rocThrust。 (飞快)
10. 执行 `bash 55.hipcub.sh` 编译 hipCUB。 (飞快)

最后一步，编译Pytorch-1.9.0 (超级超级慢)

```
sudo ln -f -s /usr/bin/python3 /usr/bin/python

git clone https://github.com/pytorch/pytorch
cd pytorch
git checkout v1.9.0
git submodule update --init --recursive

git apply /home/work/rocm-build/patch/pytorch-rocm43-1.patch

sudo apt install -y libopencv-highgui4.2 libopenblas-dev python3-dev python3-pip
pip3 install -r requirements.txt
export PATH=/opt/rocm/bin:$PATH \
    ROCM_PATH=/opt/rocm \
    HIP_PATH=/opt/rocm/hip 
export PYTORCH_ROCM_ARCH=gfx1010
python3 tools/amd_build/build_amd.py
USE_ROCM=1 USE_NINJA=1 python3 setup.py bdist_wheel

pip3 install dist/torch-1.9.0a0+gitd69c22d-cp38-cp38-linux_x86_64.whl

```

这样，我们就得到了一个只能在navi10下运行的pytorch。

我本地没有测试的硬件，现在至少没有编译错误了。有啥问题，敬请告知。多谢多谢。

---

2020-12-27
spacefish 测试了 RX 5700，发现mnist能训练，但是loss没减小，所以说还是有问题。
<https://github.com/RadeonOpenCompute/ROCm/issues/1306#issuecomment-751414407>

