#!/usr/bin/env bash

# To run this script, use:
# source install-JNBTools.sh

START_DIR=$(pwd)
builtin cd $HOME

echo 'Downloading JNBTools...'
wget 'https://github.com/Weeks-UNC/JNBTools/archive/master.zip'

echo 'Extracting JNBTools...'
unzip master.zip && mv JNBTools-master JNBTools
rm master.zip

export PYTHONPATH="$PYTHONPATH:$HOME/JNBTools/"
export PATH="$PATH:$HOME/JNBTools/"
echo 'export PYTHONPATH="$PYTHONPATH:$HOME/JNBTools/"' >> .bash_$USER
echo 'export PATH="$PATH:$HOME/JNBTools/"' >> .bash_$USER

builtin cd JNBTools

echo 'JNBTools added to PATH, installation complete'

builtin cd $START_DIR
