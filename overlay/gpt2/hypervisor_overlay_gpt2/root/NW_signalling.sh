#!/bin/bash
set -x
cd "$( dirname "${BASH_SOURCE[0]}" )"
SIGNALLING="/root/shared_with_VM/signalling.txt"
# The below query have been taken from https://github.com/Instruction-Tuning-with-GPT-4/GPT-4-LLM
QUERY1="How can we reduce air pollution?"
QUERY2="Describe the structure of an atom."
QUERY3="Give three tips for staying healthy."
QUERY4="What are the three primary colors?"
QUERY5="What is the capital of France?"
./NW_signalling_LLM $SIGNALLING "${QUERY1}" "${QUERY2}" \
"${QUERY3}" "${QUERY4}" "${QUERY5}" > /root/signalling_log.log 2>&1 &
SIG_PROC_ID=$!
