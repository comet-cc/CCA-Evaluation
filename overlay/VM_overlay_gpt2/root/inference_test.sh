#!/bin/bash
set -x

nice -n -20 /root/llama-cli -m /root/gpt2.gguf -p "Where is London?" -n 80
