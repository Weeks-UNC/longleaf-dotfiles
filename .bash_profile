# .bash_profile

# Load dot files
for file in ~/.{bash,prompt,alias,functions,env};
  do [ -f "$file" ] && source "$file";
done;
unset file;

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH
