# .bash_profile

# Load dot files
for file in ~/.{bashrc,prompt,alias,functions,env,bash_$USER};
  do [ -f "$file" ] && source "$file";
done;
unset file;
