#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}")"
set -x
taskset -c 1 ./create_realm_VM_100_reserved_memory.sh
