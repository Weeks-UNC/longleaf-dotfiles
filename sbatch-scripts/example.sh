#!/bin/bash
#SBATCH --job-name=first_slurm_job
#SBATCH --ntasks=1
#SBATCH --time=1:00
#SBATCH --mem=100

echo "Hello SLURM"
