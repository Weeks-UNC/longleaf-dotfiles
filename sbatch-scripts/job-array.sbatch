#!/usr/bin/env bash
#SBATCH --job-name=shapemapper
#SBATCH --output=sbatch_out/shapemapper_%A_%a.out
#SBATCH --array=0-2
#SBATCH --time=3:00:00
#SBATCH --ntasks=6
#SBATCH --nodes=1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=YOUR_EMAIL_GOES_HERE

# INSTRUCTIONS
################################################################################
# 1. Copy this file to the directory you want to run it in.
# 2. Edit the strings under 'declare -a samples=(' to match each of the sample
#    names to give to ShapeMapper.
# 3. Edit line 4 of this file to match the number of samples defined in step 1.
# 4. If you want email notifications, edit mail-user above or...
#    If not, delete the lines with mail-type and mail-user.
# 5. Save changes to this file.
# 6. Make sure that sbatch_out directory already exists, this is where the log
#    file will end up. Use this command: "mkdir -p sbatch_out"
# 7. Submit job array to longleaf: "sbatch job-array.sbatch"

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
# :!ringmapper.py -h

declare -a samples=(
    "Shape-incell"
    "Shape-cellfree"
    "Shape-IVT"
)
declare -a modified_folders=(
    "Sample_1"
    "Sample_2"
    "Sample_3"
)
declare -a untreated_folders=(
    "Sample_4"
    "Sample_5"
    "Sample_6"
)

s=${samples[$SLURM_ARRAY_TASK_ID]}
m=${modified_folders[$SLURM_ARRAY_TASK_ID]}
u=${untreated_folders[$SLURM_ARRAY_TASK_ID]}
# RNA name from shapemapper, taken from the sequence name INSIDE your fasta file.
t='rnasep'
# fasta file
fa='rnasep.fa'
# ct file
ct='RNaseP.ct'
# directory with input files (usually shapemapper_out/
smo="shapemapper_out/"
# ringmapper output directory
rmo="ringmapper_out/"
# pairmapper output directory
pmo="pairmapper_out/"
# arcplot output directory
apo="arcplot_out/"
# create output directories only if they don't exist already
mkdir -p ${rmo} ${pmo} ${apo}

shapemapper --target ${fa} \
            --name $s \
            --modified --folder ${m} \
            --untreated --folder ${u} \
            --amplicon \
            --output-parsed-mutations \
            --per-read-histograms \
            --overwrite

ringmapper.py --fasta ${fa} \
              --untreated ${sm}${s}_Untreated_${t}_parsed.mut \
              --undersample 1000000 \
              ${smo}${s}_Modified_${t}_parsed.mut \
              ${rmo}${s}-${t}.corrs

pairmapper.py --profile ${sm}${s}_${t}_profile.txt \
              --untreated_parsed ${sm}${s}_Untreated_${t}_parsed.mut \
              --modified_parsed ${sm}${s}_Modified_${t}_parsed.mut \
              --out ${pm}${s}-${t} \
              --override_qualcheck \
              --notDMS

arcPlot.py --ct ${ct} \
           --ringsig ${rmo}${s}-${t}.corrs \
           --profile ${smo}${s}_${t}.shape \
           ${apo}${s}-${t}-ringsig.pdf

# Adds a table of SLURM jobs stats: pending time, job time, CPU and memory usage. This will be at the end of the SBATCH output file.
sacct -j $SLURM_JOB_ID --format='JobID, submit, start, elapsed, cputime, MaxRSS'
