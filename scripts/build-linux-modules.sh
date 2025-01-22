#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/aemfvp-a-rme

export CROSS_COMPILE=$LINUX_CROSS_COMPILE
echo "$CROSS_COMPILE"
export PATH=$PATH:$LINUX_GCC_PATH
echo "$PATH"
export ARCH=$LINUX_ARCH
echo "$ARCH"
cd $DIR/../linux-external-modules
make

