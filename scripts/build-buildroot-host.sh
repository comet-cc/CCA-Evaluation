#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
experiment="base"
clean_flag="0"
while getopts "c:e:" opt; do
	case $opt in
	c)
		clean_flag=$OPTARG
		;;
	e)
		experiment=$OPTARG
		;;
	esac
done

$DIR/container/container.sh run  -V ${DIR}/../. -c "./scripts/build-buildroot-script.sh -e ${experiment} -c ${clean_flag}"
