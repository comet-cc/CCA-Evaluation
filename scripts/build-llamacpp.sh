#!/bin/bash
set -x
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

$DIR/llamacpp-builder/container.sh build
$DIR/llamacpp-builder/container.sh run
cp $DIR/../llama.cpp/build/bin/llama-cli $DIR/../overlay/VM_overlay_gpt2/root/.

