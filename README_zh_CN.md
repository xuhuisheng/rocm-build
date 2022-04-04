# rocm-build 5.1

[English Version](README.md)

### 感谢

感谢 [rigtorp](https://github.com/rigtorp) 提供的 <https://gist.github.com/rigtorp/d9483af100fb77cee57e4c9fa3c74245> ，包含了编译HIP的构建步骤。

感谢 [jlgreathouse](https://github.com/jlgreathouse) 提供的 <https://github.com/RadeonOpenCompute/Experimental_ROC> ，包含了ROCm-2.0的构建步骤。

### 开始

我的构建环境是 Ubuntu-20.04.3 。

首先使用 repo 下载项目源码 <https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html#getting-the-rocm-source-code>，
然后根据你当前的环境修改 `env.sh` 里的路径。

执行 `source env.sh` 设置环境变量。

执行 `bash install-dependency.sh` 安装依赖。

然后按照序号顺序执行脚本。

祝你好运。

---

### 使用repo下载源码

```
sudo apt install -y repo

mkdir -p ~/ROCm/
cd ~/ROCm/
repo init -u https://github.com/RadeonOpenCompute/ROCm.git -b roc-5.1.x
repo sync
```

ubuntu-20.04下是无法直接使用apt安装repo的，官方说是repo团队对python3的支持太慢了。
<https://askubuntu.com/questions/1247103/why-is-the-repo-package-unavailable-in-ubuntu-20-04-how-can-i-install-it>

ubuntu-20.04下需要手工安装repo。

```
mkdir -p ~/bin/
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH
```

### cmake版本

**注意**：从ROCm-4.2开始，编译rocBLAS需要cmake-3.16.8。ubuntu-20.04默认的cmake版本是cmake-3.16.3。
需要下载<https://cmake.org/files/v3.16/cmake-3.16.8-Linux-x86_64.tar.gz>，解压到`/home/work/local`目录，
再执行`source env.sh`将这个cmake加入PATH环境变量。
如果想要使用其他路径，可以修改`env.sh`。

### 更多文档:

* [gfx803](gfx803/README_zh_CN.md) - ROCm-4.0不再支持gfx803显卡，我只有一块RX580，要研究怎么让gfx803苟延残喘。
* [navi10](navi10/README_zh_CN.md) - 构建navi10的试验脚本。
* [navi14](navi14/README_zh_CN.md) - 构建navi14的试验脚本。
* [navi21](navi21/README_zh_CN.md) - 构建navi21的试验脚本。
* [check](check/README_zh_CN.md) - 检查ROCm能否正常运行的一些代码。

