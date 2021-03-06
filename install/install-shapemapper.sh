#!/usr/bin/env bash

# To run this script, use:
# source install-shapemapper.sh

START_DIR=$(pwd)
builtin cd $HOME

echo 'Downloading shapemapper...'
wget 'https://github.com/Weeks-UNC/shapemapper2/releases/download/2.1.5/shapemapper-2.1.5.tar.gz'

echo 'Extracting shapemapper...'
tar xzf shapemapper-2.1.5.tar.gz
rm shapemapper-2.1.5.tar.gz

export PATH="$PATH:$HOME/shapemapper-2.1.5/"
echo 'export PATH="$PATH:$HOME/shapemapper-2.1.5/"' >> .bash_$USER
echo 'Shapemapper added to PATH, installation successful'

builtin cd $START_DIR
