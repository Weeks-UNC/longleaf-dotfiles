Longleaf Dotfiles
================================================================================
Configuration and installation on the Longleaf computing cluster.

Before starting:
--------------------------------------------------------------------------------
You will need access to Longleaf:
1. Go to [ONYEN services](https://its.unc.edu/onyen-services/)
2. Click on 'Subscribe to Services' and enter your information.

Setting Up:
--------------------------------------------------------------------------------
Log into Longleaf and install git:
```
ssh <your-onyen>@longleaf.unc.edu
Password: <your-password>
module load git
module save
vi install-dotfiles.sh
```
Copy and paste the text from [install-dotfiles.sh](install/install-dotfiles.sh).
Close ViM.
```
source install-dotfiles.sh
```
