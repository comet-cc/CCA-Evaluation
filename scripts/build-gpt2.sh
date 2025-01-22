#!/bin/bash
set -x

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
$DIR/build-buildroot2.sh -e gpt2
$DIR/build-buildroot.sh -e gpt2
