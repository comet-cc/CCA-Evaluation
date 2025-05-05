#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
while getopts "c:e:" opt; do
	case $opt in
	e)
		experiment=$OPTARG
		;;
	esac
done

if [ -z "${experiment}" ]; then
        echo "Error: -e option is required."
        exit 1
fi

TARGET_DIR="$DIR/../overlay/${experiment}/VM_overlay_${experiment}/root"
if [ "$experiment" == "mobilenet" ]; then
wget -O $DIR/../tmp/mobilenet_model.tgz https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_2018_02_22/mobilenet_v1_1.0_224.tgz
tar -xzv -C $DIR/../tmp -f $DIR/../tmp/mobilenet_model.tgz
wget -O $DIR/../tmp/mobilenet_labels.tgz https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_1.0_224_frozen.tgz
tar -xzv -C $DIR/../tmp mobilenet_v1_1.0_224/labels.txt -f $DIR/../tmp/mobilenet_labels.tgz
cp $DIR/../tmp/mobilenet_v1_1.0_224/labels.txt $TARGET_DIR/.
cp $DIR/../tmp/mobilenet_v1_1.0_224.tflite $TARGET_DIR/.
fi
