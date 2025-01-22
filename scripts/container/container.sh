#!/bin/bash

# Copyright (c) 2023, ARM Limited and Contributors. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# Neither the name of ARM nor the names of its contributors may be used
# to endorse or promote products derived from this software without specific
# prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

set -e
export LANG=C

# Script path is the context for container
CONTEXT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Defaults
HOST_DIR=""
HOST_DIR1=""
HOST_ARCH=$(uname -m)
DOCKER_FILE="aemfvp-a-rme-${HOST_ARCH}"
IMAGE_NAME="aemfvp-builder-test-main-reset"
OVERWRITE="false"


function usage()
{
    echo "Usage: $0 [OPTIONS] [COMMAND]"
    echo ""
    echo "If no options are provided the script uses the default values"
    echo "defined in the 'Defaults' section."
    echo ""
    echo "Available options are:"
    echo "  -v  <path> absolute path to mount into the container;"
    echo "  -f  <file> docker file name;"
    echo "  -i  <name> docker image name;"
    echo "  -o  overwrites a previous built image;"
    echo "  -h  displays this help message and exits;"
    echo ""
    echo "Available commands are:"
    echo "  build  builds the docker image;"
    echo "  run    runs the container in interactive mode;"
    echo ""
    exit 1
}

function cmd_error_msg()
{
    echo "Error: Only one command is accepted at a time."
    echo "       See usage below."
    echo ""
    usage
}

function root_error_msg()
{
    echo "Error: Executing with root permissions is not allowed."
    exit 1
}

function build_image()
{
    echo "Building docker image: $IMAGE_NAME ..."

    if [ "${OVERWRITE}" = "true" ]; then
        echo "Removing existing docker image ${IMAGE_NAME}"
        docker rmi -f ${IMAGE_NAME} || true
    fi

    docker build \
        --rm \
        --network host \
        -f ${CONTEXT}/container-files/${DOCKER_FILE} \
        --tag=${IMAGE_NAME} \
        --build-arg USER=${USER} \
        --build-arg UID=$(id -u) \
        --build-arg GID=$(id -g) \
        ${CONTEXT}
    return 0
}

function run_image()
{
    echo "Running docker image: $IMAGE_NAME ..."

    # Reset parameters to null
    PARAMS=""

    # Mount points to be added to the container
    [ -z $HOST_DIR ] || PARAMS="${PARAMS} -v $HOST_DIR:$HOST_DIR"
    [ -z $HOST_DIR1 ] || PARAMS="${PARAMS} -v $HOST_DIR1:$HOST_DIR1 -w $HOST_DIR1"
    docker run \
        ${PARAMS} \
        --env="DISPLAY" \
        --network host \
        --user ${USER}:${USER} \
        -t \
        -i \
        ${IMAGE_NAME}
}

while [ $# -gt 0 ]; do
    while getopts :v:f:i:ohw:V: opt; do
        case $opt in
            v)
                HOST_DIR=$OPTARG
                ;;
            V)
                HOST_DIR1=$OPTARG
                ;;
            f)
                DOCKER_FILE=$OPTARG
                ;;
            i)
                IMAGE_NAME=$OPTARG
                ;;
            o)
                OVERWRITE=true
                ;;
            h)
                usage
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                exit 1
                ;;
            :)
                echo "Option -$OPTARG requires an argument." >&2
                exit 1
                ;;
        esac
    done
    [ $? -eq 0 ] || exit 1
    # end of parameters
    [ $OPTIND -gt $# ] && break
    
    # free and reset index
    shift $[$OPTIND - 1]
    OPTIND=1
    # Allow more commands to be added, we throw an error later
    ARGS[${#ARGS[*]}]=$1
    shift
done

# Throw error if more than one command is specified
[ ${#ARGS[*]} -gt 1 ] && cmd_error_msg

# Throw error if ran as root user
[ "$EUID" -eq 0 ] && root_error_msg

case ${ARGS[*]} in
    build)
        build_image
        exit 0
        ;;
    run)
        run_image
        exit 0
        ;;
    *)
        echo "Error: Invalid or empty command."
        echo "       See usage below."
        echo ""
        usage
        ;;
esac
