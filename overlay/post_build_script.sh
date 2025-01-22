#!/bin/bash

TARGET_DIR=$1
echo "$1"
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# Copy your script
cp ${DIR}/startup.sh ${TARGET_DIR}/usr/bin/.
