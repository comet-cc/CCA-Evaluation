#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
clean_flag="0"
while getopts "c:e:" opt; do
	case $opt in
	c)
		clean_flag=$OPTARG
		;;
	esac
done

$DIR/container/container.sh run  -V ${DIR}/../. -c "./scripts/build-linux-script.sh -c ${clean_flag}"
