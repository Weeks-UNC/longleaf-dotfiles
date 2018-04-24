#!/usr/bin/env bash

# To run this script, use:
# source install_shapemapper2.sh

START_DIR=$(pwd)
builtin cd $HOME

echo 'Downloading shapemapper...'
curl -O 'http://chem.unc.edu/rna/software-files/shapemapper-2.1.3.tar.gz'

echo 'Extracting shapemapper...'
tar xzf shapemapper-2.1.3.tar.gz
rm shapemapper-2.1.3.tar.gz

export PATH="$PATH:~/shapemapper-2.1.3/"
echo 'export PATH="$PATH:~/shapemapper-2.1.3/"' >> .bash_$USER
echo 'Shapemapper added to PATH, installation successful'

builtin cd $START_DIR
