#!/bin/bash
set -x
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR/..

mkdir output
mkdir trace-files
mkdir Arm-tools
mkdir tmp
mkdir FVP
sudo apt update
sudo apt install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

git clone -b cca-full/rmm-v1.0-eac5 https://git.gitlab.arm.com/linux-arm/linux-cca.git linux
cp -r linux ./linux-guest
git clone -b cca/rmm-v1.0-eac5 https://git.gitlab.arm.com/linux-arm/kvmtool-cca.git kvmtool
git clone -b 2023.08 https://github.com/buildroot/buildroot.git buildroot_host
cp -r ./buildroot_host ./buildroot_guest

echo "----------------------Downloading FVP------------------------"
wget -O $DIR/../tmp/FVP_Base_RevC-2xAEMvA_11.28_23_Linux64.tgz 'https://developer.arm.com/-/cdn-downloads/permalink/FVPs-Architecture/FM-11.28/FVP_Base_RevC-2xAEMvA_11.28_23_Linux64.tgz'
tar -xzv -C $DIR/../FVP -f $DIR/../tmp/FVP_Base_RevC-2xAEMvA_11.28_23_Linux64.tgz

git clone e02b597be3702174e7b47b44cd03e1da1553284b https://github.com/ggml-org/llama.cpp.git llamacpp
cd llamacpp
git checkout -f e02b597be3702174e7b47b44cd03e1da1553284b
