#!/usr/bin/env bash

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

tool_dir=$1
version=$2
variant=$3
hostarch=$(uname -m)

if  [[ "$version" =~ ^9.* ]] || [[ "$version" =~ ^10.* ]] ;then
    gnu_folder="gnu-a"
else
    gnu_folder="gnu"
fi

# Set toolchain name accordingly.
if  [[ "$version" =~ ^12.* ]]; then
    toolchain="arm-gnu-toolchain-${version}-${hostarch}-${variant}"
else
    toolchain="gcc-arm-${version}-${hostarch}-${variant}"
fi

url="https://developer.arm.com/-/media/Files/downloads/${gnu_folder}/${version}/binrel/${toolchain}.tar.xz"

echo -e "Installing ${toolchain}\n"

# Create target folder
mkdir -p ${tool_dir}/${toolchain}

# Download
wget -nv ${url}

# Extract
tar -xf ${toolchain}.tar.xz -C ${tool_dir}/${toolchain} --strip-components=1

# Clean up
rm ${toolchain}.tar.xz

