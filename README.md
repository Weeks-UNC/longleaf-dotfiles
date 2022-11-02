Longleaf Dotfiles
================================================================================
Configuration and installation on the Longleaf computing cluster.

What is it?
--------------------------------------------------------------------------------
This repository is for anything that simplifies Longleaf set-up. It contains:
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

Setting Up:
--------------------------------------------------------------------------------
First, check your path aren't overwritting the paths that are added in these
dotfiles. If you already see paths to any Weeks Lab software or RNAstructure,
you should edit the lines in your own dotfiles (`~/.bashrc` and
`~/.bash_profile`) where you are adding these to your path.

```
echo -e ${PATH//:/\\n}
echo -e ${PYTHONPATH//:/\\n}
```

Next, to make use of paths and the software in `/proj/kweeks/bin/`, add this
line to `~/.bashrc`:

```
source /proj/kweeks/bin/Longleaf-dotfiles/.bashrc
```

This will take effect on your next log in, so go ahead and log out and back in.

Finally, you should install Anaconda and use the included Anaconda environment
to run all of this software:

```
module load anaconda
conda env create -f /proj/kweeks/bin/Longleaf-dotfiles/map-env.yml
```

To activate this environment:

```
conda activate py2-MaP
```

Fingers crossed, all of the Weeks Lab software will work.


TODO:
--------------------------------------------------------------------------------
- map-pipeline:
  - create bash script wrapper to copy into working directory
  - create a README
- dedupe-samples:
  - create a README
  - discuss drawbacks of deduping with Kevin
