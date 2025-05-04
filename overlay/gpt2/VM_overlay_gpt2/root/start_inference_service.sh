#!/bin/bash
set -x
/root/memory_touch 500
/root/memory_touch 500
/root/memory_touch 500
NUM_OF_QUERIES=5
SIGNALLING_FILE="/root/shared_with_VM/signalling.txt"
set +x
for ((i=1; i<=NUM_OF_QUERIES; i++)); do
	source /root/check_state_get_addr.sh ${SIGNALLING_FILE}
	echo "Filename received from check_state_get_addr: ${filename}"
	nice -n -20 /root/llama-cli -m /root/gpt2.gguf -p "${filename}" -n 80 -t 1 --trace \
	>> /root/shared_with_VM/output.txt 2>&1
	/root/update_state "$SIGNALLING_FILE"
	echo "System state updated to 'processed' by update_state."
done
