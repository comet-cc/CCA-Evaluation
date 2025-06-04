#!/bin/bash
set -x
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

PYTHON_EXECUTABLE="python3.10"

$PYTHON_EXECUTABLE -m venv venv

pip install --upgrade pip
pip install pyyaml tuxmake termcolor numpy matplotlib graphlib
