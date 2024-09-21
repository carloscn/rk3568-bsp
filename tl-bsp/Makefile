include build.cfg
export $(shell sed 's/=.*//' build.cfg)

.PHONY: all clean distclean linux uboot

all: prepare linux uboot
docker_all:
	sudo chmod a+rw .
	make all
# Prepare dependencies
prepare:
	sudo apt install libgnutls28-dev

linux:
	@echo "[INFO] Building Linux..."
	bash build_linux.sh

uboot:
	@echo "[INFO] Building U-Boot..."
	bash build_uboot.sh

firmware:
	@echo "[INFO] Building Firmware..."
	bash build_firmware.sh

image:
	@echo "[INFO] Creating Image..."
	bash build_mkimage.sh

burn:
	@echo "[INFO] Burning Image..."
	sudo dd if=uboot.img of=/dev/${DEV}p1 conv=fsync && sync
	sudo dd if=boot.img of=/dev/${DEV}p3 conv=fsync && sync
	
clean:
	@echo "[INFO] Cleaning build files..."
	rm -rf build

distclean: clean
	@echo "[INFO] Performing distclean..."
	rm -rf optee_os optee_client optee_test optee_examples
	rm -rf ti-linux-kernel trusted-firmware-a ti-u-boot
	rm -rf openssl mbedtls util-linux
	rm -rf *.tar.gz *.bin
