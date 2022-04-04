#!/bin/bash

# ubuntu 20.04
# sudo apt install -y python-is-python3

# basic
sudo apt install -y build-essential git cmake ninja-build libnuma-dev python3 python3-pip

# 12.roct-thunk-interface
sudo apt install -y libdrm-dev zlib1g-dev libudev-dev

# 15.rocr-runtime
sudo apt install -y libelf-dev

# 16.rocminfo
sudo apt install -y pciutils

# 18.hip
sudo apt install -y mesa-common-dev \
                    dpkg-dev rpm libelf-dev rename liburi-encode-perl \
                    libfile-basedir-perl libfile-copy-recursive-perl libfile-listing-perl libfile-which-perl \
                    file doxygen

# 21.rocfft
sudo apt install -y python3-dev

# 22.rocblas
sudo apt install -y gfortran python3-venv libtinfo-dev

# 33.roctracer
pip3 install cppheaderparser

# 43.rocgdb
sudo apt install -y bison flex gcc make ncurses-dev texinfo g++ zlib1g-dev \
                    libexpat-dev python3-dev liblzma-dev libbabeltrace-dev \
                    libbabeltrace-ctf-dev

# 51.rocsolver
sudo apt install -y libfmt-dev

# 62.rock-dkms
sudo apt install -y autoconf

# 73.rocmvalidationutil
sudo apt install -y libpci3 libpci-dev doxygen unzip libpciaccess-dev

# 74.rocr_debug_agent
sudo apt install -y libdw-dev
