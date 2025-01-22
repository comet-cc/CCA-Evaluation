#!/bin/bash
set -x
Path="/root"
SourceFolderPath="${Path}/input_data" # Set the source folder path here
TargetFolderPath="${Path}/shared_with_VM" # Set the target folder path here
StateFilePath="${Path}/shared_with_VM/signalling.txt" # Use a .txt file for state and file name
Format=".bmp"
/root/NW_signalling ${SourceFolderPath} ${TargetFolderPath} ${StateFilePath} ${Format}  > /root/signalling_log.log 2>&1 &

SIG_PROC_ID=$!
