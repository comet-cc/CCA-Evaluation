#!/bin/bash
set -x
/root/memory_touch 270
/root/memory_touch 270
/root/memory_touch 270
SIGNALLING_FILE="/root/shared_with_VM/signalling.txt"
NUM_OF_IMAGES=5
set +x
for ((i=1; i<=NUM_OF_IMAGES; i++)); do
	source /root/check_state_get_addr.sh ${SIGNALLING_FILE}
	echo "Filename received from check_state_get_addr: ${filename}"
	nice -n -20 /root/realm_inference -l /root/labels.txt \
	-i "${filename}" -m /root/mobilenet_v1_1.0_224.tflite \
	-x 1 -t 1 -T 1 >> /root/shared_with_VM/output.txt 2>&1
	/root/update_state "$SIGNALLING_FILE"
	echo "System state updated to 'processed' by update_state."
done
