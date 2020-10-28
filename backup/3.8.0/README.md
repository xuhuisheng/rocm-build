# README

Download sources using repo.

```
sudo apt install -y repo

mkdir -p ~/ROCm/
cd ~/ROCm/
repo init -u https://github.com/RadeonOpenCompute/ROCm.git -b roc-3.8.x
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
