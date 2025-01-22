#!/usr/bin/env bash

# Copyright (c) 2015-2023, ARM Limited and Contributors. All rights reserved.
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

#
# This script uses the following environment variables from the variant
#
# VARIANT - build variant name
# TOP_DIR - workspace root directory
# CROSS_COMPILE - PATH to GCC including CROSS-COMPILE prefix
# PARALLELISM - number of cores to build across
# LINUX_BUILD_ENABLED - Flag to enable building Linux
# LINUX_RME_BUILD_ENABLED - Flag to enable building ARM Trusted Firmware with
# 	support for RME
# LINUX_PATH - sub-directory containing Linux code
# LINUX_ARCH - Build architecture (arm64)
# LINUX_CONFIG_LIST - List of Linaro configs to use to build
# LINUX_CONFIG_DEFAULT - the default from the list (for tools)
# LINUX_{config} - array of linux config options, indexed by
# 	path - the path to the linux source
#	defconfig - a defconfig to build
#	config - the list of config fragments
# TARGET_BINS_PLATS - the platforms to create binaries for
# TARGET_{plat} - array of platform parameters, indexed by
#	fdts - the fdt pattern used by the platform
# UBOOT_UIMAGE_ADDRS - address at which to link UBOOT image
# UBOOT_MKIMAGE - path to uboot mkimage
# LINUX_ARCH - the arch
# UBOOT_BUILD_ENABLED - flag to indicate the need for uimages.
# LINUX_IMAGE_TYPE - Image or zImage (Image is the default if not specified)
# LINUX_GCC_PATH - Path where the compiler is installed
# VARIANT_LINUX_GNU - The compiler variant
# OUTPUT_DIR - Directory where build products are stored
#
PARALLELISM1=20
do_build ()
{
	echo
	echo -e "${GREEN}Building Linux for $PLATFORM on [`date`]${NORMAL}"
	echo

	if [ "$LINUX_BUILD_ENABLED" == "1" ]; then
		export ARCH=$LINUX_ARCH
		for name in $LINUX_CONFIG_LIST; do
			local lpath=LINUX_$name[path];
			local lconfig=LINUX_$name[config];
			local lmodules=LINUX_$name[modules];

			echo "config: $name"
			pushd $TOP_DIR/${!lpath};
			mkdir -p $LINUX_OUT_DIR/$name
			confs=LINUX_$name[config]
			echo "confs: ${!confs}"
			if [ "${!lconfig}" != "" ]; then
				echo "Building using config fragments..."
				CONFIG=""
				for config in ${!lconfig}; do
					CONFIG=$CONFIG"linaro/configs/${config}.conf "
				done
				scripts/kconfig/merge_config.sh -O $LINUX_OUT_DIR/$name $CONFIG
				make O=$LINUX_OUT_DIR/$name -j$PARALLELISM1 $LINUX_IMAGE_TYPE dtbs
				if [ ${!lmodules} == "true" ]; then
					mkdir -p $LINUX_OUT_DIR/$name/modules
					scripts/kconfig/merge_config.sh -O $LINUX_OUT_DIR/$name/modules $CONFIG
					make O=$LINUX_OUT_DIR/$name/modules -j$PARALLELISM1 modules
				fi
			else
				echo "Building using defconfig..."
				lconfig=LINUX_$name[defconfig];
				make O=$LINUX_OUT_DIR/$name ${!lconfig}
				make O=$LINUX_OUT_DIR/$name -j$PARALLELISM1 $LINUX_IMAGE_TYPE dtbs
				if [ "${!lmodules}" == "true" ]; then
					make O=$LINUX_OUT_DIR/$name/modules ${!lconfig}
					make O=$LINUX_OUT_DIR/$name/modules -j$PARALLELISM1 modules
				fi
			fi
			popd
		done
	fi

	if [ "$LINUX_RME_BUILD_ENABLED" == "1" ]; then
		pushd $LINUX_PATH
		# Apply kconf patch which support cmd line extend to disable cpuidle.

		# Set Compiler
		export CROSS_COMPILE=$LINUX_CROSS_COMPILE
		export PATH=$LINUX_GCC_PATH:$PATH
		export ARCH=$LINUX_ARCH

		make defconfig
		./scripts/config --enable CONFIG_DMA_RESTRICTED_POOL
		./scripts/config --enable CONFIG_TUN
		./scripts/config --enable CONFIG_MACVLAN
		./scripts/config --enable CONFIG_MACVTAP
		./scripts/config --enable CONFIG_TAP
		./scripts/config --enable CONFIG_IPV6
		./scripts/config --enable CONFIG_BRIDGE
		./scripts/config --enable CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER
		./scripts/config --enable CONFIG_SAMPLES
		./scripts/config --set-str CONFIG_CMDLINE "cpuidle.off=1"
	#	./scripts/config --set-val CONFIG_CMA_SIZE_MBYTES 200
		./scripts/config --enable CONFIG_CMDLINE_EXTEND
		./scripts/config --enable CONFIG_UDMABUF
		./scripts/config --enable CONFIG_CHECKPOINT_RESTORE
		./scripts/config --enable CONFIG_MODVERSIONS
		./scripts/config --enable CONFIG_MODULE_FORCE_LOAD
		./scripts/config --enable CONFIG_SAMPLE_ARM_CCA_TEST_SUITE
		./scripts/config --disable CONFIG_HZ_250
		./scripts/config --enable CONFIG_HZ_100
	#	./scripts/config --enable CONFIG_SHARED_MEM_RESERVED_IPA_BDEVICE
	        ./scripts/config --disable CONFIG_SIMPLE_MEM_RESERVED_BLOCK
		make olddefconfig
		make -j$PARALLELISM1 modules
		make -j$PARALLELISM1 $LINUX_IMAGE
		popd
	fi
}

do_clean ()
{
	echo
	echo -e "${GREEN}Cleaning Linux for $PLATFORM on [`date`]${NORMAL}"
	echo

	if [ "$LINUX_BUILD_ENABLED" == "1" ]; then
		export ARCH=$LINUX_ARCH

		for name in $LINUX_CONFIG_LIST; do
			local lpath=LINUX_$name[path];
			pushd $TOP_DIR/${!lpath};
			make O=$LINUX_OUT_DIR/$name distclean
			popd
		done

		rm -rf $TOP_DIR/$LINUX_PATH/$LINUX_OUT_DIR
	fi

	if [ "$LINUX_RME_BUILD_ENABLED" == "1" ]; then
		pushd $LINUX_PATH
		make distclean
		make clean
		popd

		# Remove the bins copied to output-products
		rm -rf $OUTPUT_PLATFORM_DIR/Image
	fi
}

do_package ()
{
	echo
	echo -e "${GREEN}Packing Linux for $PLATFORM on [`date`]${NORMAL}"
	echo

	if [ "$LINUX_BUILD_ENABLED" == "1" ]; then
		echo "Packaging Linux... $VARIANT";
		# Copy binary to output folder
		pushd $TOP_DIR

		for name in $LINUX_CONFIG_LIST; do
			local lpath=LINUX_$name[path];
			local outpath=LINUX_$name[outpath];
			local lmodules=LINUX_$name[modules];
			mkdir -p ${OUTDIR}/${!outpath}

			cp $TOP_DIR/${!lpath}/$LINUX_OUT_DIR/$name/arch/$LINUX_ARCH/boot/$LINUX_IMAGE_TYPE ${OUTDIR}/${!outpath}/$LINUX_IMAGE_TYPE.$name
			if [ "${!lmodules}" == "true" ]; then
				cp -R $TOP_DIR/${!lpath}/$LINUX_OUT_DIR/$name/modules ${OUTDIR}/${!outpath}/modules
			fi

			if [ "$LINUX_CONFIG_DEFAULT" = "$name" ]; then
				for plat in $TARGET_BINS_PLATS; do
					local fd=TARGET_$plat[fdts]
					for target in ${!fd}; do
						for item in $target; do
							discoveredDTB=$(find $TOP_DIR/${!lpath}/$LINUX_OUT_DIR/$name/arch/$LINUX_ARCH/boot/dts -name ${item}.dtb)
							if [ "${discoveredDTB}" = "" ]; then
								echo "skipping dtb $item"
							else
								cp ${discoveredDTB} ${OUTDIR}/${!outpath}/.
							fi
						done
					done
				done
				cp ${OUTDIR}/${!outpath}/$LINUX_IMAGE_TYPE.$name ${OUTDIR}/${!outpath}/$LINUX_IMAGE_TYPE
			fi

			if [ "$UBOOT_BUILD_ENABLED" == "1" ]; then
				pushd ${OUTDIR}/${!outpath}
				for addr in $UBOOT_UIMAGE_ADDRS; do
					${UBOOT_MKIMG} -A $LINUX_ARCH -O linux -C none \
						-T kernel -n Linux \
						-a $addr -e $addr \
						-n "Linux" -d $LINUX_IMAGE_TYPE.$name uImage.$addr.$name
					if [ "$LINUX_CONFIG_DEFAULT" = "$name" ]; then
						cp uImage.$addr.$name uImage.$addr
					fi
				done
				popd
			fi
		done
	fi

	if [ "$LINUX_RME_BUILD_ENABLED" == "1" ]; then
		cp -v ${LINUX_PATH}/arch/arm64/boot/Image $OUTPUT_PLATFORM_DIR1/Image-100
		cp -v ${LINUX_PATH}/arch/arm64/boot/Image $OUTPUT_PLATFORM_DIR2/Image-100
	fi
}

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/aemfvp-a-rme
OUTPUT_PLATFORM_DIR1="$DIR/../overlay/hypervisor_overlay_base/root/VM_image"
OUTPUT_PLATFORM_DIR2="$DIR/../overlay/hypervisor_overlay_gpt2/root/VM_image"
LINUX_PATH="$DIR/../linux-guest"

do_build
do_package



