#!/usr/bin/env bash

# To run this script, use:
# source install-RNATools.sh

START_DIR=$(pwd)
builtin cd $HOME

echo 'Downloading RNATools...'
wget 'https://github.com/Weeks-UNC/RNATools/archive/master.zip'

echo 'Extracting RNATools...'
unzip master.zip && mv RNATools-master RNATools
rm master.zip

export PYTHONPATH="$PYTHONPATH:$HOME/RNATools/"
echo 'export PYTHONPATH="$PYTHONPATH:$HOME/RNATools/"' >> .bash_$USER

echo 'RNATools added to PATH, installation complete'

builtin cd $START_DIR
