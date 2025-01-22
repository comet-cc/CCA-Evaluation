#!/bin/bash
set -x

while getopts "o:e:" opt; do
	case $opt in
            o)
                 overlay=$OPTARG
            ;;
            e)
                 EXPERIMENT=$OPTARG
            ;;
	esac
done

if [ -z "${EXPERIMENT}" ]; then
	echo "Error: -e option is required."
	exit 1
fi

cd "$( dirname "${BASH_SOURCE[0]}" )"/../buildroot_${EXPERIMENT}
make kvmtool-dirclean
make kvmtool-rebuild
cd ../scripts
./build-buildroot2.sh -e ${EXPERIMENT}
./build-buildroot.sh -e ${EXPERIMENT}

