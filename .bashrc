# .bashrc

##########################
# !! IMPORTANT NOTICE !! #
##########################
# It is STRONGLY recommended that you NOT manually place module commands in
# this file. Instead use the module save or savelist commands
# to manage the module(s) you want to automatically load at login time.
#
# Please see http://help.unc.edu/help/modules-approach-to-software-management/
# for more details on module usage.


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions


#===============================================================================
#   Change Prompts
#===============================================================================
export PS1="________________________________________________________________________________\n|[\@] \w @ \h (\u) \n| => "
export PS2="| => "

#===============================================================================
#   Set Paths
#===============================================================================
#   Ensure user-installed binaries take precedence
export PATH=~/bin:$PATH
export PATH="/usr/local/git/bin:/sw/bin/:/usr/local/bin:/usr/local/:/usr/local/sbin:/usr/local/mysql/bin:$PATH"
export PYTHONPATH="$PYTHONPATH:~/bin"

alias config='/usr/bin/git --git-dir=/nas/longleaf/home/psirving/.cfg/ --work-tree=/nas/longleaf/home/psirving'
