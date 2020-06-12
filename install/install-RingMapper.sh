#!/usr/bin/env bash

# To run this script, use:
# source install-RingMapper.sh

START_DIR=$(pwd)
builtin cd $HOME

echo 'Downloading RingMapper...'
wget 'https://github.com/Weeks-UNC/RingMapper/archive/master.zip'

echo 'Extracting RingMapper...'
tar xzf master.zip && mv RingMapper-master RingMapper
rm master.zip

export PYTHONPATH="$PYTHONPATH:$HOME/RingMapper/"
echo 'export PYTHONPATH="$PYTHONPATH:$HOME/RingMapper/"' >> .bash_$USER

builtin cd RingMapper
echo 'Running setup.py...'
python setup.py build_ext --inplace

echo 'Running test.sh'
./test.sh

echo 'RingMapper added to PATH, installation complete'
echo 'Note: if you did not receive the message "All tests PASSED", this needs'
echo 'to be addressed manually.'

builtin cd $START_DIR
