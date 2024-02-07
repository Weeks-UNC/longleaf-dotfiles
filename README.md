Longleaf Dotfiles
================================================================================
Configuration and installation on the Longleaf computing cluster.

What is it?
--------------------------------------------------------------------------------
"Dotfiles" are the hidden files that begin with a period (e.g., `.bashrc`).
These files specify configuration settings in certain contexts.

This repository is for anything that makes using Longleaf easier. It contains:
- convenient aliases, functions, and environment variables
- An anaconda environment that will work with all of our MaP software.
- installation scripts and template SLURM submission scripts for common software
- A pipeline which submits Shapemapper, Ringmapper, Pairmapper, arcPlot,
  Dancemapper, and foldClusters in parallel as seperate SLURM jobs.
- A script to deduplicate samples prior to running the MaP pipeline.

Before starting:
--------------------------------------------------------------------------------
You will need access to Longleaf:
1. Go to [ONYEN services](https://its.unc.edu/onyen-services/)
2. Click on 'Subscribe to Services' and enter your information.

[More information about Longleaf](https://help.rc.unc.edu/longleaf-cluster/)

Setting Up:
--------------------------------------------------------------------------------
First, check your `$PATH` and `$PYTHONPATH` variables.

```
echo -e ${PATH//:/\\n}
echo -e ${PYTHONPATH//:/\\n}
```

If you already see paths to any Weeks Lab software or RNAstructure,
you should edit the lines in your own dotfiles (`~/.bashrc` and
`~/.bash_profile`) where you are adding these to your path.

Next, to make use of paths and the software in `/proj/kweeks/bin/`, add this
line to `~/.bashrc`:

```
source /proj/kweeks/bin/Longleaf-dotfiles/.bashrc
```

This will take effect on your next log in, so go ahead and log out and back in.

Finally, if you are not already using Anaconda, you should install Anaconda and
use the included Anaconda environment to run Weeks Lab software. If you have
another python module loaded, remove it first:

```
module list
module rm python # if necessary
module load anaconda
module save
conda env create -f /proj/kweeks/bin/Longleaf-dotfiles/map-env.yml
```

To activate this environment:

```
conda activate py2-MaP
```

[More information on managing conda environments](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html).

An important note for conda environments: don't use pip install, it can mess things up.

Fingers crossed, all of the Weeks Lab software will work.

TODO:
--------------------------------------------------------------------------------
- map-pipeline:
  - create bash script wrapper to copy into working directory
  - create a README
- dedupe-samples:
  - create a README
  - discuss drawbacks of deduping with Kevin
