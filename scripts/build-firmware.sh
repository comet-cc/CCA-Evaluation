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
                $SETTING=$OPTARG
                ;;
        esac
done
set -x
SHRINKWRAP_LOC="$DIR/../shrinkwrap/shrinkwrap/shrinkwrap"
#export PATH="$DIR/../shrinkwrap/shrinkwrap:$PATH"
#shrinkwrap build cca-3world-customized.yaml --no-sync-all
$SHRINKWRAP_LOC build cca-3world-customized-${SETTING}.yaml 
