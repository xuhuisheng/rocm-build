# rocm-build 5.1

[中文版](README_zh_CN.md)

### Thanks

Thanks [rigtorp](https://github.com/rigtorp) providing intial build steps <https://gist.github.com/rigtorp/d9483af100fb77cee57e4c9fa3c74245> , which contains build steps for HIP on ROCm-3.6.

Thanks [jlgreathouse](https://github.com/jlgreathouse) providing <https://github.com/RadeonOpenCompute/Experimental_ROC> , which contains build steps for ROCm-2.0.

### Start

My environment is Ubuntu-20.04.3.

Please download sources using repo <https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html#getting-the-rocm-source-code>,
and change the path of source in `env.sh`.

Execute `source env.sh` to setup environment variables.

Execute `bash install-dependency.sh` to install dependencies

Then execute bash scripts by order number.

Good luck.

---

### Download sources using repo.

```
sudo apt install -y repo

mkdir -p ~/ROCm/
cd ~/ROCm/
repo init -u https://github.com/RadeonOpenCompute/ROCm.git -b roc-5.1.x
repo sync
```

Notice: there is no repo package on ubuntu-20.04, because of slow support for python3.
<https://askubuntu.com/questions/1247103/why-is-the-repo-package-unavailable-in-ubuntu-20-04-how-can-i-install-it>

Download and install repo manually on ubuntu-20.04.

```
mkdir -p ~/bin/
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH
```

### cmake version

**Note**: rocBLAS need cmake-3.16.8 from ROCm-4.2. The version of default cmake from ubuntu-20.04 is cmake-3.16.3.
We have to download <https://cmake.org/files/v3.16/cmake-3.16.8-Linux-x86_64.tar.gz> and unpack it to `/home/work/local`,
and execute `source env.sh` to add custom cmake to PATH environment variables.
If you want to use other location, please modify `env.sh`.

### Additional documentations:

* [gfx803](gfx803) - AMD drop gfx803 offical support on ROCm-4.0, since gfx803 is my only GPU, I need find a way to let it work longer.
* [navi10](navi10) - Experiment scripts for building navi10 GPU.
* [navi14](navi14) - Experiment scripts for building navi14 GPU.
* [navi21](navi21) - Experiment scripts for building navi21 GPU.
* [check](check) - Codes for check whether ROCm can run successfully.

