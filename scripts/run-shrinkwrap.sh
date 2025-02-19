#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

SETTING="without-trace"
while getopts "e:s:" opt; do
        case $opt in
        e)
                experiment=$OPTARG
                ;;
	s)
                SETTING=$OPTARG
                ;;
        esac
done

if [ -z "${experiment}" ]; then
	echo "Error: -e option is required."
	exit 1
fi

SHRINKWRAP_LOC="$DIR/../shrinkwrap/shrinkwrap/shrinkwrap"
set -x

if [ $SETTING == "without-trace" ]; then
	$SHRINKWRAP_LOC run cca-3world-customized-$SETTING.yaml \
	--rtvar=KERNEL=$DIR/../output/Image-$experiment \
	--rtvar=ROOTFS=$DIR/../output/host-fs-$experiment.ext4

elif [ $SETTING == "trace" ]; then
	$SHRINKWRAP_LOC run cca-3world-customized-$SETTING.yaml \
	--rtvar=KERNEL=$DIR/../output/Image-$experiment \
	--rtvar=ROOTFS=$DIR/../output/host-fs-$experiment.ext4 \
	--rtvar=GenericPATH=$DIR/../Arm-tools/GenericTrace.so \
	--rtvar=TogglePATH=$DIR/../Arm-tools/ToggleMTIPlugin.so \
	--rtvar=TRACEDIR=$DIR/../trace-files
fi


