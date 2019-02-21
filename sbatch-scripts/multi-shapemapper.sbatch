#!/usr/bin/env bash
#SBATCH --job-name=shapemapper
#SBATCH --output=shapemapper_%A_%a.out
#SBATCH --array=0-3
#SBATCH --time=1:00:00
#SBATCH --mem=10g
#SBATCH --partition=general
#SBATCH --ntasks=6
#SBATCH --nodes=1
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
"~/shapemapper-2.1.3/shapemapper --target reference.fa --name 'experiment-1' --overwrite --min-depth 4000 --modified --folder 1plus --untreated --folder 1minus --output-classified"
"~/shapemapper-2.1.3/shapemapper --target reference.fa --name 'experiment-2' --overwrite --min-depth 4000 --modified --folder 2plus --untreated --folder 2minus --output-classified"
"~/shapemapper-2.1.3/shapemapper --target reference.fa --name 'experiment-3' --overwrite --min-depth 4000 --modified --folder 3plus --untreated --folder 3minus --output-classified"
"~/shapemapper-2.1.3/shapemapper --target reference.fa --name 'experiment-4' --overwrite --min-depth 4000 --modified --folder 4plus --untreated --folder 4minus --output-classified"
)
eval ${tasks[$SLURM_ARRAY_TASK_ID]}

sacct -j $SLURM_JOB_ID --format='JobID, user, priority, submit, start, elapsed, cputime, totalCPU, ncpus, NTasks, ExitCode'
