#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

SETTING="without-trace"
clean_flag="0"
while getopts "c:s:" opt; do
        case $opt in
        c)
                clean_flag="1"
                ;;
        s)
                SETTING=$OPTARG
                ;;
        esac
done
SHRINKWRAP_LOC="$DIR/../shrinkwrap/shrinkwrap/shrinkwrap"

if [ $SETTING == "trustzone" ]; then
	$SHRINKWRAP_LOC build cca-4world-customized.yaml
else
	$SHRINKWRAP_LOC build cca-3world-customized-${SETTING}.yaml
fi
