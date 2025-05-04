#!/bin/bash

size="$1"
/root/marker -f 5
/root/memory_touch "${size}"
echo "/root/memory_touch  $1"
/root/marker -f 6
