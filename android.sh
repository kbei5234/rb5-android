#!/bin/sh -x

NAME=aosp2

rm -rf $NAME
mkdir -p $NAME; cd $NAME
rm -rf linaro-vendor-package

# get device into fastboot mode
adb devices
adb root
adb reboot bootloader
fastboot devices

# update bootloader binaries
git clone https://gerrit.devboardsforandroid.linaro.org/linaro-vendor-package
cd linaro-vendor-package
cd src/rb5/rb5-bootloader-ufs-aosp/
./flashall

# remove any previous images
rm -rf userdata.img
rm -rf super.img
rm -rf vendor_boot.img
rm -rf boot.img

# install prebuilt aosp images from google
wget https://snapshots.linaro.org/96boards/dragonboard845c/linaro/aosp-master/1630/userdata.img
wget https://snapshots.linaro.org/96boards/dragonboard845c/linaro/aosp-master/1630/super.img
wget https://snapshots.linaro.org/96boards/dragonboard845c/linaro/aosp-master/1630/vendor_boot.img
wget https://snapshots.linaro.org/96boards/dragonboard845c/linaro/aosp-master/1630/boot.img

# flash downloaded aosp images while in fastboot mode
fastboot flash userdata userdata.img
fastboot flash super super.img
fastboot flash vendor_boot vendor_boot.img
fastboot flash boot boot.img

fastboot reboot
