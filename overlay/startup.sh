#!/bin/bash
set -x

#for i in {1..1}; do
#	source /root/NW_signalling.sh
#	taskset -c 1 /root/marker -f 71
#	taskset -c 1 /root/create_realm_VM_100.sh 
#	if kill -0 $SIG_PROC_ID 2> /dev/null; then
#		echo "Killing NW_signalling with PID $NW_PROC_ID"
#   		kill $SIG_PROC_ID
#	fi
#done
#for i in {1..1}; do
#	source /root/NW_signalling.sh
#	taskset -c 1 /root/marker -f 72
#	taskset -c 1 /root/create_NW_VM_100.sh
#	if kill -0 $SIG_PROC_ID 2> /dev/null; then
#		echo "Killing NW_signalling with PID $NW_PROC_ID"
#		kill $SIG_PROC_ID
#	fi
#done
#poweroff
