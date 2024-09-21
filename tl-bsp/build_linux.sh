# !/bin/bash

source build.cfg

if [ ! -d "tlrk-linux" ]; then
	echo "[INFO] linux does not exist, Downloading linux..."
    git clone ${LINUX_REPO} -b ${LINUX_BRANCH} --depth=1 tlrk-linux
fi
if [ $? -eq 0 ]; then
    echo "[INFO] Pull tlrk-linux done!"
else
    echo "[ERR] Pull tlrk-linux failed."
    exit -1
fi

pushd tlrk-linux
cp -rfv arch/arm64/configs/rk356x_robot.config arch/arm64/configs/rk356x_robot_defconfig
make CROSS_COMPILE=${CROSS_COMPILE} ARCH=arm64 rk356x_robot_defconfig
make CROSS_COMPILE=${CROSS_COMPILE} ARCH=arm64 -j16
${CROSS_COMPILE}size --format=sysv vmlinux
${CROSS_COMPILE}size vmlinux
popd

echo "[INFO] Build Linux done!"