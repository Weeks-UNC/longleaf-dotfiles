#!/usr/bin/env bash

# To run this script, use:
# source install-arcPlot.sh

START_DIR=$(pwd)
builtin cd $HOME

echo 'Downloading arcPlot...'
wget 'https://github.com/Weeks-UNC/arcPlot/archive/master.zip'

echo 'Extracting arcPlot...'
tar xzf master.zip && mv arcPlot-master arcPlot
rm master.zip

export PYTHONPATH="$PYTHONPATH:$HOME/arcPlot/"
echo 'export PYTHONPATH="$PYTHONPATH:$HOME/arcPlot/"' >> .bash_$USER

builtin cd arcPlot

echo 'arcPlot added to PATH, installation complete'

builtin cd $START_DIR
