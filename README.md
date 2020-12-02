# rocm-build

Thanks [rigtorp](https://github.com/rigtorp) providing intial build steps <https://gist.github.com/rigtorp/d9483af100fb77cee57e4c9fa3c74245> , which contains build steps for HIP on ROCm-3.6.

Thanks [jlgreathouse](https://github.com/jlgreathouse) providing <https://github.com/RadeonOpenCompute/Experimental_ROC> , which contains build steps for ROCm-2.0.

My environment is Ubuntu-20.04.1.

Please download sources using repo <https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html#getting-the-rocm-source-code>,
and change the path of source in `env.sh`.

Execute `source env.sh` to setup environment variables, then execute bash scripts by order number.

Good luck.

---

Download sources using repo.

```
sudo apt install -y repo

mkdir -p ~/ROCm/
cd ~/ROCm/
repo init -u https://github.com/RadeonOpenCompute/ROCm.git -b roc-3.10.x
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

---

Install dependencies

```
sudo apt -y install git cmake build-essential libnuma-dev ninja-build python3 python3-pip
```

