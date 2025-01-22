#!/bin/bash
set -x

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
MOUNT=$(cd ${DIR}/llama.cpp && pwd)
cd $MOUNT
cmake -B build -DBUILD_SHARED_LIBS=OFF
cmake --build build --config Release -j 20

