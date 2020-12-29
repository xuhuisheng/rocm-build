# rocm-build 4.0.0

[English Version](README.md)

感谢 [rigtorp](https://github.com/rigtorp) 提供了最初的构建步骤 <https://gist.github.com/rigtorp/d9483af100fb77cee57e4c9fa3c74245> ，包含了编译HIP的构建步骤。

感谢 [jlgreathouse](https://github.com/jlgreathouse) 提供的 <https://github.com/RadeonOpenCompute/Experimental_ROC> ，包含了ROCm-2.0的构建步骤。

我的构建环境是 Ubuntu-20.04.1 。

首先使用 repo 下载项目源码 <https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html#getting-the-rocm-source-code>，
然后根据你当前的环境修改 `env.sh` 里的路径。

执行 `source env.sh` 设置环境变量。

然后按照序号顺序执行脚本。

安装依赖

```
sudo apt -y install git cmake build-essential libnuma-dev ninja-build python3 python3-pip
```

祝你好运。

---

使用repo下载源码

```
sudo apt install -y repo

mkdir -p ~/ROCm/
cd ~/ROCm/
repo init -u https://github.com/RadeonOpenCompute/ROCm.git -b roc-4.0.x
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

