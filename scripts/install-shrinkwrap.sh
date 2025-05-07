#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR/..

sudo apt-get install git netcat-openbsd python3 python3-pip telnet
sudo pip3 install pyyaml termcolor tuxmake
git clone https://git.gitlab.arm.com/tooling/shrinkwrap.git

cd shrinkwrap
git checkout -f 31f3ecfb75e83e44e150f65f89049358ce819f0c
git apply ../patch/shrinkwrap.patch
cd ..
cp ./shrinkwrap-configs/* ./shrinkwrap/config/.
