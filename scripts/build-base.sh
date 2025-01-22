#!/bin/bash
set -x

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
$DIR/build-buildroot2.sh
$DIR/build-buildroot.sh
