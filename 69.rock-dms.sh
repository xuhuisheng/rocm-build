
mkdir -p build/rock-dkms

cd build/rock-dkms

cp -R ~/ROCm/ROCK-Kernel-Driver/drivers/gpu/drm/amd .

cp ~/ROCm/ROCK-Kernel-Driver/drivers/gpu/drm/amd/dkms/dkms.conf .

ln -s amd/dkms/Makefile Makefile

mkdir -p firmware
mkdir -p include

cp -R ~/ROCm/ROCK-Kernel-Driver/include/drm include/
cp -R ~/ROCm/ROCK-Kernel-Driver/include/kcl include/
cp -R ~/ROCm/ROCK-Kernel-Driver/include/linux include/
cp -R ~/ROCm/ROCK-Kernel-Driver/include/uapi include/

cp -R ~/ROCm/ROCK-Kernel-Driver/drivers/gpu/drm/scheduler scheduler
cp -R ~/ROCm/ROCK-Kernel-Driver/drivers/gpu/drm/ttm ttm



