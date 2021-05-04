#!/usr/bin/env bash

# Copy this file to the directory you want to run it in.
# Pick the job types you want to use.
# Copy and paste the command for how many samples you want to run.
# Edit the file names and flags to match your experiments.
# Save and quit.
# Run this command: bash -x inline-examples.sbatch

# SHAPE MAPPER
###############################################################################
sbatch -t 120 \
--ntasks=6 \
--nodes=1 \
-o output-file.out \
--wrap="shapemapper \
        --target reference.fa \
        --name 'experiment-name' \
        --overwrite \
        --min-depth 4000 \
        --modified \
        --folder plus \
        --untreated \
        --folder minus \
        --output-classified"


# RING MAPPER
###############################################################################
