#!/bin/bash

sudo dnf -y groupinstall "Development Tools" && sudo dnf -y install ninja-build cmake libglvnd-devel numactl-devel numactl python3 git
