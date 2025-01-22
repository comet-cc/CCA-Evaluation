#!/bin/bash
set -x

nice -n -20 /root/llama-cli -m /dev/my_mem_exposed -p "Where is London?" -n 80
