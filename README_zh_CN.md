# rocm-build 4.1.0

[English Version](README.md)

感谢 [rigtorp](https://github.com/rigtorp) 提供的 <https://gist.github.com/rigtorp/d9483af100fb77cee57e4c9fa3c74245> ，包含了编译HIP的构建步骤。

感谢 [jlgreathouse](https://github.com/jlgreathouse) 提供的 <https://github.com/RadeonOpenCompute/Experimental_ROC> ，包含了ROCm-2.0的构建步骤。

我的构建环境是 Ubuntu-20.04.2 。

首先使用 repo 下载项目源码 <https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html#getting-the-rocm-source-code>，
然后根据你当前的环境修改 `env.sh` 里的路径。

执行 `source env.sh` 设置环境变量。

安装依赖

```
sudo apt -y install git cmake build-essential libnuma-dev ninja-build python3 python3-pip python-is-python3
```

然后按照序号顺序执行脚本。

祝你好运。

---

使用repo下载源码

```
sudo apt install -y repo

mkdir -p ~/ROCm/
cd ~/ROCm/
repo init -u https://github.com/RadeonOpenCompute/ROCm.git -b roc-4.1.x
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

---

更多文档:

* [gfx803](gfx803/README_zh_CN.md) - ROCm-4.0不再支持gfx803显卡，我只有一块RX580，要研究怎么让gfx803苟延残喘。
* [navi10](navi10/README_zh_CN.md) - 构建navi10的试验脚本。
* [navi14](navi14/README_zh_CN.md) - 构建navi14的试验脚本。
* [navi21](navi21/README_zh_CN.md) - 构建navi21的试验脚本。
* [check](check/README_zh_CN.md) - 检查ROCm能否正常运行的一些代码。

