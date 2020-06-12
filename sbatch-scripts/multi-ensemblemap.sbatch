#!/usr/bin/env bash
#SBATCH --job-name=ensemblemap
#SBATCH --output=ensemblemap_%A_%a.out
#SBATCH --array=0-3
#SBATCH --time=24:00:00
################################################################################
# Edit the strings under 'declare -a tasks=(' to match your experiments.
#
# The --array variable creates an array [0,1,2,3]. Change it so that the length
# is how many jobs you need (same as number of strings under $tasks).
#
# This script is submitted that many times, but only one line from $tasks is
# evaluated each time.
#
# To call this script:
# sbatch multi-shapemapper.sbatch
################################################################################
declare -a tasks=(
"EnsembleMap.py --profile NAI_7SK_profile.txt --outputprefix NAI_7SK --modified_parsed NAI_Modified_7SK_parsed.mut --fit"
"EnsembleMap.py --profile 2API_7SK_profile.txt --outputprefix 2API_7SK --modified_parsed 2API_Modified_7SK_parsed.mut --fit"
"EnsembleMap.py --profile CDI_7SK_profile.txt --outputprefix CDI_7SK --modified_parsed CDI_Modified_7SK_parsed.mut --fit"
"EnsembleMap.py --profile DMS_7SK_profile.txt --outputprefix DMS_7SK --modified_parsed DMS_Modified_7SK_parsed.mut --fit"
)
eval ${tasks[$SLURM_ARRAY_TASK_ID]}

sacct -j $SLURM_JOB_ID --format='JobID, user, priority, submit, start, elapsed, cputime, totalCPU, ncpus, NTasks, ExitCode'

# usage: EnsembleMap.py [-h] [--modified_parsed MODIFIED_PARSED]
#                       [--profile PROFILE] [--mincoverage MINCOVERAGE]
#                       [--minrxbg MINRXBG] [--undersample UNDERSAMPLE] [--fit]
#                       [--maxcomponents MAXCOMPONENTS] [--trials TRIALS]
#                       [--badcol_cutoff BADCOL_CUTOFF] [--writeintermediates]
#                       [--priorWeight PRIORWEIGHT] [--ring] [--window WINDOW]
#                       [--pairmap] [--untreated_parsed UNTREATED_PARSED]
#                       [--readfromfile READFROMFILE] [--suppressverbal]
#                       [--outputprefix OUTPUTPREFIX] [--subwindow]
# 
# Fit BM model to data
# 
# required arguments:
#   --modified_parsed MODIFIED_PARSED
#                         Path to modified parsed.mut file
#   --profile PROFILE     Path to profile.txt file
# 
# quality filtering options:
#   --mincoverage MINCOVERAGE
#                         Minimum coverage (integer number of nts) required for
#                         read to be included in cacluations
#   --minrxbg MINRXBG     Set nts with rx-bg less than this to inactive
#                         (default=0.002)
#   --undersample UNDERSAMPLE
#                         Only cluster with this number of reads. By default
#                         this option is disabled and all reads are used
#                         (default=-1).
# 
# options for fitting data:
#   --fit                 Flag specifying to fit data
#   --maxcomponents MAXCOMPONENTS
#                         Maximum number of components to fit (default=5)
#   --trials TRIALS       Maximum number of fitting trials at each component
#                         number (default=50)
#   --badcol_cutoff BADCOL_CUTOFF
#                         Inactivate column after it causes a failure X number
#                         of times *after* a valid soln has already been found
#                         (default=5)
#   --writeintermediates  Write each BM solution to file with specified prefix.
#                         Will be saved as prefix-
#                         intermediate-[component]-[trial].bm
#   --priorWeight PRIORWEIGHT
#                         Weight of prior on Mu (default=0.001). Prior =
#                         priorWeight*readDepth*bgRate at each nt. Prior is
#                         disabled by passing -1, upon which a naive prior is
#                         used.
# 
# options for performing RING analysis on clustered reads:
#   --ring
#   --window WINDOW       Window size for computing correlations (default=1)
#   --pairmap             Run PAIR-MaP analysis on clustered reads
# 
# optional arguments:
#   -h, --help            show this help message and exit
#   --untreated_parsed UNTREATED_PARSED
#                         Path to modified parsed.mut file
#   --readfromfile READFROMFILE
#                         Read in model from BM file
#   --suppressverbal      Suppress verbal output
#   --outputprefix OUTPUTPREFIX
#                         Write output files with this prefix (default=emfit)
#   --subwindow           Subtract window when doing RING calcs
