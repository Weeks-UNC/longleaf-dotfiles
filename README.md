Longleaf Dotfiles
================================================================================
Configuration and installation on the Longleaf computing cluster.

What is it?
--------------------------------------------------------------------------------
This repository is for anything that simplifies Longleaf set-up. It contains:
- convenient aliases, functions, and environment variables
- installation scripts and template SLURM submission scripts for common software

Before starting:
--------------------------------------------------------------------------------
You will need access to Longleaf:
1. Go to [ONYEN services](https://its.unc.edu/onyen-services/)
2. Click on 'Subscribe to Services' and enter your information.

Setting Up:
--------------------------------------------------------------------------------
First, a note: Following these steps will move your current .bash_profile and
.bashrc to a new directory called .config_backup. If you want to customize your
environment, you should put them in a file called ".bash_<your-onyen>". For
example, mine would be ".bash_psirving". This file will be loaded every time
you log in, but it won't be tracked by git.

Log into Longleaf and install git:
```
ssh <your-onyen>@longleaf.unc.edu
Password: <your-password>
module load git
module save
```
Copy the install-dotfiles.sh file from this repo, and run it.
```
wget 'https://raw.githubusercontent.com/Weeks-UNC/longleaf-dotfiles/master/install/install-dotfiles.sh'
source install-dotfiles.sh
```

TODO:
--------------------------------------------------------------------------------
- [ ] pipeline: put sample name in job name for easy reference
