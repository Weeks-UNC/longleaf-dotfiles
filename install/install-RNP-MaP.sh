#!/usr/bin/env bash

# To run this script, use:
# source install-RNP-MaP.sh

START_DIR=$(pwd)
builtin cd $HOME

echo 'Downloading RNP-MaP...'
wget 'https://github.com/Weeks-UNC/RNP-MaP/archive/master.zip'

echo 'Extracting RNP-MaP...'
unzip master.zip && mv RNP-MaP-master RNP-MaP
rm master.zip

export PYTHONPATH="$PYTHONPATH:$HOME/RNP-MaP/"
echo 'export PYTHONPATH="$PYTHONPATH:$HOME/RNP-MaP/"' >> .bash_$USER

echo 'RNP-MaP added to PATH, installation complete'

builtin cd $START_DIR
