#!/usr/bin/env bash

# Copyright (c) 2023, ARM Limited and Contributors. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# Neither the name of ARM nor the names of its contributors may be used
# to endorse or promote products derived from this software without specific
# prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# This script uses the following environment variables from the variant
#
# BUILDROOT_PATH - Directory containing the buildroot source
# LINUX_PATH - Directory containing the linux source
# BUILDROOT_GCC_PATH - Path where the compiler is installed
# VARIANT_LINUX_GNU - The compiler variant
# BUILDROOT_CONFIG_FILE - Path of the configuration file used to build
# OUTPUT_DIR - Directory where build products are stored
#
PARALLELISM1=20
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
#QEMU_PATH="${DIR}/../qemu"
KVMTOOL_PATH="${DIR}/../kvmtool"
while getopts "c:e:" opt; do
	case $opt in
	c)
		clean_flag=$OPTARG
		;;
	e)
		experiment=$OPTARG
		;;
	esac
done

do_build ()
{
	echo
	echo -e "${GREEN}Building Buildroot for $PLATFORM on [`date`]${NORMAL}"
	echo

	pushd $BUILDROOT_PATH
	# Set Compiler
	export CROSS_COMPILE=$BUILDROOT_CROSS_COMPILE
	export PATH=$BUILDROOT_GCC_PATH:$PATH
	# Enable build of KvmTool & set up the path
	cp ${BUILDROOT_CONFIG_FILE} .config
	echo "KVMTOOL_OVERRIDE_SRCDIR = ${KVMTOOL_PATH}" > local.mk
#	echo "QEMU_OVERRIDE_SRCDIR = ${QEMU_PATH}" >> local.mk
	# Set the overlays needed on the host-fs
	./utils/config --set-val BR2_ROOTFS_OVERLAY "\"${ROOTFS_OVERLAY}\""
	./utils/config --set-val BR2_ROOTFS_POST_BUILD_SCRIPT "\"${POST_BUILD_SCRIPT}\""
	make oldconfig
	make BR2_JLEVEL=$PARALLELISM1

	popd
}

do_clean ()
{
	echo
	echo -e "${GREEN}Cleaning Buildroot for $PLATFORM on [`date`]${NORMAL}"
	echo

	pushd $BUILDROOT_PATH
	make clean

	# Remove the temporary overlays if they are left in from previous incompelte builds
	rm -rf $PWD/tmp_realm_overlay
	rm -rf $PWD/tmp_kvm_overlay
	popd
}

do_package ()
{
	echo
	echo -e "${GREEN}Packing Buildroot for $PLATFORM on [`date`]${NORMAL}"
	echo

        rm -rf $OUTPUT_PLATFORM_DIR/host-fs.ext4
	cp -v $BUILDROOT_PATH/output/images/rootfs.ext4 $OUTPUT_PLATFORM_DIR/host-fs-$experiment.ext4
}


source $DIR/aemfvp-a-rme
BUILDROOT_CONFIG_FILE="${DIR}/../overlay/hypervisor_buildroot_config_${experiment}"
OUTPUT_PLATFORM_DIR="${DIR}/../output"
ROOTFS_OVERLAY="${DIR}/../overlay/hypervisor_overlay_${experiment}"
POST_BUILD_SCRIPT="${DIR}/../overlay/post_build_script.sh"
BUILDROOT_PATH="${DIR}/../buildroot_${experiment}"

if [ "$clean_flag" == "1" ]; then
	do_clean
else
	# remove previously overlayed data from previous build in the root directory to avoid any issue.
	rm -rf ${BUILDROOT_PATH}/output/target/root/*
fi

do_build
do_package
