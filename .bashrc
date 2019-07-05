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

#load all dot-files
for file in ~/.{prompt,alias,functions,env,bash_$USER};
  do [ -f "$file" ] && source "$file";
done;
unset file;

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
