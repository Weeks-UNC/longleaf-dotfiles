#!/usr/bin/env bash
#SBATCH --job-name=pairmapper
#SBATCH --output=pairmapper_%A_%a.out
#SBATCH --array=0-3
#SBATCH --time=1:00:00
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=<your-email-address>


################################################################################
# 1. Copy this file to the directory you wish to run it from.
# 1. Edit the strings under 'declare -a tasks=(' to match your experiments.
# 2. Edit array above to match the number of tasks defined in step 1.
# 3. If you want email notification, edit mail-user above
# 4. If not, delete the lines with mail-type and mail-user.
#
# The --array variable above creates an inclusive array, i.e. 0-3 = 0,1,2,3.
# One job is submitted for each value, which is stored as SLURM_ARRAY_TASK_ID.
# Below, this value is used with eval to run one task per job. You can pick and
# choose which tasks are evaluated. For example, to ignore tasks 4-7 out of 16:
#     --array=0-3,8-15
#
# To submit the job array to longleaf:
# sbatch multi-shapemapper.sbatch
################################################################################


declare -a tasks=(
"pairmapper.py --profile NAI-SSII_RMRP_profile.txt --untreated_parsed NAI-SSII_Untreated_RMRP_parsed.mut --undersample 400000 --modified_parsed NAI-SSII_Modified_RMRP_parsed.mut --out NAI-SSII-RMRP"
"pairmapper.py --profile 2API-SSII_RMRP_profile.txt --untreated_parsed 2API-SSII_Untreated_RMRP_parsed.mut --undersample 400000 --modified_parsed 2API-SSII_Modified_RMRP_parsed.mut --out 2API-SSII-RMRP"
"pairmapper.py --profile CDI-SSII_RMRP_profile.txt --untreated_parsed CDI-SSII_Untreated_RMRP_parsed.mut --undersample 400000 --modified_parsed CDI-SSII_Modified_RMRP_parsed.mut --out CDI-SSII-RMRP"
"pairmapper.py --profile DMS-SSII_RMRP_profile.txt --untreated_parsed DMS-SSII_Untreated_RMRP_parsed.mut --undersample 400000 --modified_parsed DMS-SSII_Modified_RMRP_parsed.mut --out DMS-SSII-RMRP"
)

eval ${tasks[$SLURM_ARRAY_TASK_ID]}

# Adds a table of SLURM jobs stats: pending time, job time, CPU and memory usage. This will be at the end of the SBATCH output file.
sacct -j $SLURM_JOB_ID --format='JobID, submit, start, elapsed, cputime, MaxRSS'

# usage: pairmapper.py [-h] [--modified_parsed MODIFIED_PARSED]
#                      [--untreated_parsed UNTREATED_PARSED] [--profile PROFILE]
#                      [--out OUT] [--undersample UNDERSAMPLE]
#                      [--ignorents IGNORENTS] [--mincoverage MINCOVERAGE]
#                      [--chisq_cut CHISQ_CUT] [--highbg_rate HIGHBG_RATE]
#                      [--highbg_corr HIGHBG_CORR]
#                      [--mincorrdistance MINCORRDISTANCE] [--mindepth MINDEPTH]
#                      [--mincount MINCOUNT]
#                      [--primary_reactivity PRIMARY_REACTIVITY]
#                      [--primary_zscore PRIMARY_ZSCORE]
#                      [--secondary_reactivity SECONDARY_REACTIVITY]
#                      [--secondary_zscore SECONDARY_ZSCORE] [--reagent REAGENT]
# 
# Detect base pairs from correlated DMS data
# 
# required arguments:
#   --modified_parsed MODIFIED_PARSED
#                         Path to Modified parsed.mut
#   --untreated_parsed UNTREATED_PARSED
#                         Path to Untreated parsed.mut
#   --profile PROFILE     Path to profile.txt
#   --out OUT             output prefix
# 
# optional arguments:
#   -h, --help            show this help message and exit
#   --undersample UNDERSAMPLE
#                         Randomly undersample specified number of reads from
#                         modified file (default=-1 [disabled]).
#   --ignorents IGNORENTS
#                         A list of comma-separated (1-indexed) nts to ignore
#                         (e.g. 10,12,35)
#   --mincoverage MINCOVERAGE
#                         Quality filter reads by requiring a minimum number of
#                         positional matches to reference sequence. This
#                         parameter can be set as a fraction of the total
#                         molecule length (i.e. if 0.8 is passed, reads will be
#                         required to have at least 0.8*len(fasta) valid
#                         matches) Alternatively, an integer value can be passed
#                         (i.e. if 150 is passed, reads will be required to have
#                         at least 150 valid matches). By default, this filter
#                         is disabled.
#   --chisq_cut CHISQ_CUT
#                         Set chisq cutoff (default = 20)
#   --highbg_rate HIGHBG_RATE
#                         Ignore nt position with bg reactivity above this
#                         value. For PAIR-MaP analysis, windows with bg 3X this
#                         rate will be ignored
#   --highbg_corr HIGHBG_CORR
#                         Ignore nt pairs correlated in the bg sample, with
#                         correlation determined via this significance value
#                         (default=10.83 --> P=1e-3)
#   --mincorrdistance MINCORRDISTANCE
#                         Minimum distance allowed between correlations (default
#                         = 5)
#   --mindepth MINDEPTH   Minimum pairwise read depth allowed for calculating
#                         correlations (default = 10000)
#   --mincount MINCOUNT   Minimum required count in contigency table (default =
#                         50). Nt pairs with fewer than this number of
#                         comutations are ignored
#   --primary_reactivity PRIMARY_REACTIVITY
#                         Reactivity cutoff for primary correlations (default =
#                         0.2)
#   --primary_zscore PRIMARY_ZSCORE
#                         Zscore cutoff for primary correlations (default = 2.0)
#   --secondary_reactivity SECONDARY_REACTIVITY
#                         Reactivity cutoff for secondary correlations (default
#                         = 0.5)
#   --secondary_zscore SECONDARY_ZSCORE
#                         Zscore cutoff for secondary correlations (default =
#                         2.0)
#   --reagent REAGENT     The reagent used in this experiment, either SHAPE or
#                         DMS. (default = DMS)
