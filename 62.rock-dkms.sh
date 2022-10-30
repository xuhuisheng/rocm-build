
set -e

TARGET_DIR=$ROCM_BUILD_DIR/rock-dkms/usr/src/amdgpu-5.3-63

mkdir -p $TARGET_DIR

cd $TARGET_DIR

cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/drivers/gpu/drm/amd $TARGET_DIR

# cp $ROCM_GIT_DIR/ROCK-Kernel-Driver/drivers/gpu/drm/amd/dkms/dkms.conf $TARGET_DIR

ln -sf amd/dkms/Makefile $TARGET_DIR/Makefile
ln -sf amd/dkms/dkms.conf $TARGET_DIR/dkms.conf

mkdir -p $TARGET_DIR/firmware
mkdir -p $TARGET_DIR/include

# cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/drm $DIST_DIR/include/
# cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/kcl $TARGET_DIR/include/
# cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/linux $TARGET_DIR/include/
# cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/uapi $TARGET_DIR/include/

cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/drivers/gpu/drm/scheduler $TARGET_DIR/scheduler/
cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/drivers/gpu/drm/ttm $TARGET_DIR/ttm/

mkdir -p $TARGET_DIR/include/drm
cp $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/drm/amd_asic_type.h $TARGET_DIR/include/drm/
cp $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/drm/amd_rdma.h $TARGET_DIR/include/drm/
cp $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/drm/gpu_scheduler.h $TARGET_DIR/include/drm/
cp $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/drm/spsc_queue.h $TARGET_DIR/include/drm/
mkdir -p $TARGET_DIR/include/drm/ttm
cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/drm/ttm/* $TARGET_DIR/include/drm/ttm/
mkdir -p $TARGET_DIR/include/kcl
cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/kcl/* $TARGET_DIR/include/kcl/
mkdir -p $TARGET_DIR/include/linux
cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/linux/dma-resv.h $TARGET_DIR/include/linux/
cp -R $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/kcl/reservation.h $TARGET_DIR/include/linux/
mkdir -p $TARGET_DIR/include/uapi/drm
cp $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/uapi/drm/amdgpu_drm.h $TARGET_DIR/include/uapi/drm/
mkdir -p $TARGET_DIR/include/uapi/linux
cp $ROCM_GIT_DIR/ROCK-Kernel-Driver/include/uapi/linux/kfd_ioctl.h $TARGET_DIR/include/uapi/linux/
mkdir -p $TARGET_DIR/amd/amdkcl/dma-buf
cp $ROCM_GIT_DIR/ROCK-Kernel-Driver/drivers/dma-buf/dma-resv.c $TARGET_DIR/amd/amdkcl/dma-buf/

cd $TARGET_DIR/amd/dkms/
bash autogen.sh
cd ../..

cd ../../..
cp ../../meta/rock-dkms_5.3-63_all . -R
cp -R usr rock-dkms_5.3-63_all/

dpkg -b rock-dkms_5.3-63_all

