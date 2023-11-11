
#!/bin/bash

# Set the path to your buildroot directory
BUILDROOT_DIR=~/buildroot

# Set the path to your project directory
PROJECT_DIR=$(pwd)

# Set the name of your defconfig file
DEFCONFIG_FILE=raspberrypi3_64_defconfig

# Create a build directory
mkdir -p $PROJECT_DIR/build

# Change to the build directory
cd $PROJECT_DIR/build

# Configure the build
make -C $BUILDROOT_DIR O=$PROJECT_DIR/build BR2_EXTERNAL=$PROJECT_DIR $DEFCONFIG_FILE

# Build the project
make -C $BUILDROOT_DIR O=$PROJECT_DIR/build BR2_EXTERNAL=$PROJECT_DIR -j8

