
#!/bin/bash

# Set the path to your buildroot directory
BUILDROOT_DIR=~/buildroot

# Set the path to your project directory
PROJECT_DIR=$(pwd)

# Set the name of your defconfig file
DEFCONFIG_FILE=xraspberrypi3_64_defconfig


export BRI=$PROJECT_DIR/build/images
# Configure the build
if [ "$1" == "build" ]; then
    make O=$PROJECT_DIR BR2_EXTERNAL=$PROJECT_DIR -C $BUILDROOT_DIR 
    make -j8
elif [ "$1" == "run" ]; then
    qemu-system-aarch64 -machine raspi3b -cpu cortex-a72 -nographic -dtb $BRI/bcm2710-rpi-3-b-plus.dtb -m 1G -smp 4 -kernel $BRI/Image -sd $BRI/sdcard.img \
    -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1"
# if arg is defsize, resize the sdcard image
elif [ "$1" == "defsize" ]; then
    echo "Resizing sdcard.img to 8G"
    qemu-img resize $BRI/sdcard.img 8G
elif [ "$1" == "menu" ]; then
    echo "Running menuconfig"
    BR2_DEFCONFIG=$PROJECT_DIR
    if [ -f $PROJECT_DIR/build/.config ]; then
        BR2_DEFCONFIG=$PROJECT_DIR/build/.config
    fi
    make O=$PROJECT_DIR/build BR2_EXTERNAL=$PROJECT_DIR -C $BUILDROOT_DIR $BR2_DEFCONFIG menuconfig
    
else
    echo "Invalid argument. Usage: ./build.sh [build|run|defsize]"
fi

