#!/bin/bash
set -x
/root/marker -f 2
nice -n -20 /root/start_inference_service.sh
/root/marker -f 3
poweroff
