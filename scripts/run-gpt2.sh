#!/bin/bash
set -x
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
$DIR/run-shrinkwrap.sh gpt2
