#!/usr/bin/env bash

# To run this script, use:
# source install-ensemble-map.sh

START_DIR=$(pwd)
builtin cd $HOME

echo 'Downloading Ensemble-MaP...'
wget 'https://github.com/Weeks-UNC/Ensemble-MaP/archive/v1.0-alpha.tar.gz'

echo 'Extracting Ensemble-MaP...'
tar xzf v1.0-alpha.tar.gz && mv v1.0-alpha Ensemble-MaP
rm v1.0-alpha.tar.gz

export PATH="$PATH:$HOME/Ensemble-MaP/"
echo 'export PYTHONPATH="$PYTHONPATH:$HOME/Ensemble-MaP/"' >> .bash_$USER

builtin cd ./Ensemble-MaP/
echo 'Running setup.py...'
python setup.py build_ext --inplace

echo 'Ensemble-MaP added to PATH, installation complete.'
echo 'Note: Any errors in running setup.py should be manually addressed.'

builtin cd $START_DIR
