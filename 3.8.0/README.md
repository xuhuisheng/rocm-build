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

