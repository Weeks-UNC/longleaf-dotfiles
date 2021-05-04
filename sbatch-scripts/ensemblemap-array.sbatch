#!/usr/bin/env bash
#SBATCH --job-name=ensemblemap
#SBATCH --output=ensemblemap_%A_%a.out
#SBATCH --array=0-2
#SBATCH --time=6-00:00:00
#SBATCH --mem=10g
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=<your-email-address>

# INSTRUCTIONS
################################################################################
# 1. Copy this file to the directory you want to run it in.
# 2. Edit the strings under 'declare -a samples=(' to match each of the sample
#    names given to ShapeMapper.
# 3. Edit line 4 of this file to match the number of samples defined in step 1.
# 4. If you want email notifications, edit mail-user above or...
#    If not, delete the lines with mail-type and mail-user.
# 5. Save changes to this file.
# 6. Make sure that sbatch_out directory already exists, this is where the log
#    file will end up. Use this command: "mkdir -p sbatch_out"
# 7. Submit job array to longleaf: "sbatch ensemblemap-array.sbatch"

# EXPLAINATION
###############################################################################
# The --array variable above creates an inclusive array, i.e. 0-3 = 0,1,2,3.
# One job is submitted for each value. Value is stored as SLURM_ARRAY_TASK_ID.
# This value is used on the samples array to store the current sample in 's'.
# 's' is used to change the file name inputs and outputs to ringmapper.py.

# TIPS
###############################################################################
# If you are editing from vi, and want to view the help output for a command
# type this in the vi command line:
# :!EnsembleMap.py -h

declare -a samples=(
"DMS-cellfree"
"DMS-incell"
"DMS-IVT"
)

s=${samples[$SLURM_ARRAY_TASK_ID]}
# RNA name from shapemapper, taken from the sequence name INSIDE your fasta file.
t='rnasep'
# directory with input files (usually shapemapper_out/
smo="shapemapper_out/"
# ringmapper output directory
emo="ensemblemap_out/"
# create output directories only if they don't exist already
mkdir -p ${emo}

EnsembleMap.py --profile ${smo}${s}_${t}_profile.txt \
               --outputprefix ${emo}${s}-${t} \
               --modified_parsed ${s}_Modified_${t}_parsed.mut \
               --fit

# Adds a table of SLURM jobs stats: pending time, job time, CPU and memory usage. This will be at the end of the SBATCH output file.
sacct -j $SLURM_JOB_ID --format='JobID, submit, start, elapsed, cputime, MaxRSS'
