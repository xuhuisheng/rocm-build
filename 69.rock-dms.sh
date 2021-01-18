
mkdir -p $ROCM_BUILD_DIR/rock-dkms

cd $ROCM_BUILD_DIR/rock-dkms

cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/drivers/gpu/drm/amd .

cp $ROCM_GIT_DIR/ROCK-Kernel-Driver/drivers/gpu/drm/amd/dkms/dkms.conf .

ln -s amd/dkms/Makefile Makefile

mkdir -p firmware
mkdir -p include

cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/drm include/
cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/kcl include/
cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/linux include/
cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/uapi include/

cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/drivers/gpu/drm/scheduler scheduler
cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/drivers/gpu/drm/ttm ttm



