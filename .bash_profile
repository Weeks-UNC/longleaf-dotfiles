# .bash_profile

# Load dot files
for file in ~/.{bashrc,prompt,alias,functions,env};
  do [ -f "$file" ] && source "$file";
done;
unset file;

# User specific environment and startup programs

export PATH=$HOME/.local/bin:$HOME/bin:$PATH
export SCR=/pine/scr/p/s/psirving
export MS=/ms/home/p/s/psirving

