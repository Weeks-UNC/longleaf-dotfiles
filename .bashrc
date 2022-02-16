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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/nas/longleaf/apps/anaconda/2019.10/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/nas/longleaf/apps/anaconda/2019.10/etc/profile.d/conda.sh" ]; then
        . "/nas/longleaf/apps/anaconda/2019.10/etc/profile.d/conda.sh"
    else
        export PATH="/nas/longleaf/apps/anaconda/2019.10/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

