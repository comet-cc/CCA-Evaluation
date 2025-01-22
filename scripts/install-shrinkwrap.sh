#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR/..

sudo apt-get install git netcat-openbsd python3 python3-pip telnet
sudo pip3 install pyyaml termcolor tuxmake
git clone https://git.gitlab.arm.com/tooling/shrinkwrap.git
export PATH=$PWD/shrinkwrap/shrinkwrap:$PATH

cp ./shrinkwrap-configs/cca-3world-customized.yaml ./shrinkwrap/config/.
