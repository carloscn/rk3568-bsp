# !/bin/bash

source build.cfg

if [ ! -d "tlrk-uboot" ]; then
	echo "[INFO] linux does not exist, Downloading linux..."
    git clone ${UBOOT_REPO} -b ${UBOOT_BRANCH} --depth=1 tlrk-uboot
fi
if [ $? -eq 0 ]; then
    echo "[INFO] Pull tlrk-uboot done!"
else
    echo "[ERR] Pull tlrk-uboot failed."
    exit -1
fi

pushd tlrk-uboot
cp make.sh make.sh.bak
sed -i 's|CROSS_COMPILE_ARM64=.*|CROSS_COMPILE_ARM64=${ARCH64_CROSS_COMPILE}|g' make.sh
sed -i 's|CROSS_COMPILE_ARM32=.*|CROSS_COMPILE_ARM32=${ARCH32_CROSS_COMPILE}|g' make.sh
make clean
bash make.sh rk3568  && \
bash make.sh env && \
bash make.sh uboot && \
bash make.sh elf
cp make.sh.bak make.sh
popd

echo "[INFO] Build uboot done!"