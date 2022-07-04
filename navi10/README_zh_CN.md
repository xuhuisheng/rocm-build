# navi10

[English Version](README.md)

Date: 2022-07-05

社区希望ROCm支持navi10 - RX5700XT好长时间了。

感谢比特币大跌，让我有一个机会用低于2000元买到RX5700XT。

最终，让我们结束这个持续了对我来说已经两年的问题吧。对背景讨论感兴趣的同学可以看这个链接 <https://github.com/RadeonOpenCompute/ROCm/issues/887> 。

---

这里是针对navi10 GPU - RX5700XT的实验性构建脚本。

**AMD官方还不支持navi10，就算编译成功也无法保证ROCm能支持RX5700XT。**

---

代码基于 ROCm-5.2.0，请参考 <https://github.com/xuhuisheng/rocm-build/blob/master/README_zh_CN.md> 准备构建环境，OS是 Ubuntu-20.04.3。

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
需要为navi10重新编译4个组件。

1. 执行 `bash 21.rocfft.sh` 编译 rocFFT。 (超级超级慢)
2. 执行 `bash 24.rocrand.sh` 编译 rocRAND。 (很快)
3. 执行 `bash navi10/25.rocsparse.sh` 编译 rocSPARSE，需要打个补丁。(很慢)
4. 执行 `bash 27.rccl.sh` 编译 rccl. (很慢)

最后一步，编译Pytorch-1.12.0 (超级超级慢)

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
export PYTORCH_ROCM_ARCH=gfx1010
python3 tools/amd_build/build_amd.py
USE_ROCM=1 USE_NINJA=1 python3 setup.py bdist_wheel

pip3 install dist/torch-1.12.0a0+git67ece03-cp38-cp38-linux_x86_64.whl

```

这样，我们就得到了一个只能在navi10下运行的pytorch。

---

mnist在RX5700XT运行成功。

祝好运
