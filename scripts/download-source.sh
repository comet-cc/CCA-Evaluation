#!/bin/bash
set -x
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR/..

mkdir output
mkdir output/aemfvp-a-rme
mkdir trace

git clone -b cca-full/rmm-v1.0-eac5 https://git.gitlab.arm.com/linux-arm/linux-cca.git linux
cp -r linux ./linux-guest
git clone -b cca/rmm-v1.0-eac5 https://git.gitlab.arm.com/linux-arm/kvmtool-cca.git kvmtool
git clone -b 2023.08 https://github.com/buildroot/buildroot.git buildroot_base
cp -r ./buildroot_base ./buildroot2_base

