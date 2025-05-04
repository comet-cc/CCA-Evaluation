#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}")"
set -x
taskset -c 1 ./create_NW_VM_100.sh
