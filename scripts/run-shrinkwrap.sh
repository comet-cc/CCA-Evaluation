#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

while getopts "e:" opt; do
        case $opt in
        e)
                experiment=$OPTARG
                ;;
        esac
done

if [ -z "${experiment}" ]; then
	echo "Error: -e option is required."
	exit 1
fi

set -x

shrinkwrap run cca-3world-reset.yaml \
--rtvar=KERNEL=$DIR/../output/Image \
--rtvar=ROOTFS=$DIR/../output/host-fs-$experiment.ext4 \
--rtvar=GenericPATH=$DIR/../plugins/GenericTrace.so \
--rtvar=TogglePATH=$DIR/../plugins/ToggleMTIPlugin.so \
--rtvar=TRACEDIR=$DIR/../trace-files 


#--rtvar=SHARE=$DIR/../mnt
