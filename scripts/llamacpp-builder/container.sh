#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR
MOUNT=$( cd ${DIR}/../../llama.cpp && pwd)
echo $MOUNT
IMAGE_NAME="arm64-builder-llama2"

if [ "$1" == "build" ]; then
docker build \
	--rm \
	--platform linux/arm64 \
        --network host \
	-f ./dockerfile \
	--tag=${IMAGE_NAME} \
	--build-arg USER=${USER} \
	--build-arg UID=$(id -u) \
	--build-arg MOUNT=${MOUNT} \
	--build-arg GID=$(id -g) .

elif [ "$1" == "run" ]; then
	docker run \
	--privileged \
        --memory="16g" \
	--network host \
    	--env="DISPLAY" \
        --platform linux/arm64 \
	-v $MOUNT:$MOUNT -it \
	${IMAGE_NAME}

else
    echo "Invalid Argument"
    exit 1
fi
