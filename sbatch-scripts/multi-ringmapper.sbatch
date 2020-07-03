#!/usr/bin/env bash
#SBATCH --job-name=ringmapper
#SBATCH --output=ringmapper_%A_%a.out
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
"ringmapper.py --fasta RMRP.fa --untreated NAI-SSII_Untreated_RMRP_parsed.mut --undersample 400000 NAI-SSII_Modified_RMRP_parsed.mut NAI-SSII-RMRP.corrs"
"ringmapper.py --fasta RMRP.fa --untreated 2API-SSII_Untreated_RMRP_parsed.mut --undersample 400000 2API-SSII_Modified_RMRP_parsed.mut 2API-SSII-RMRP.corrs"
"ringmapper.py --fasta RMRP.fa --untreated CDI-SSII_Untreated_RMRP_parsed.mut --undersample 400000 CDI-SSII_Modified_RMRP_parsed.mut CDI-SSII-RMRP.corrs"
"ringmapper.py --fasta RMRP.fa --untreated DMS-SSII_Untreated_RMRP_parsed.mut --undersample 400000 DMS-SSII_Modified_RMRP_parsed.mut DMS-SSII-RMRP.corrs"
)

eval ${tasks[$SLURM_ARRAY_TASK_ID]}

# Adds a table of SLURM jobs stats: pending time, job time, CPU and memory usage. This will be at the end of the SBATCH output file.
sacct -j $SLURM_JOB_ID --format='JobID, submit, start, elapsed, cputime, MaxRSS'

# usage: ringmapper.py [-h] [--fasta FASTA] [--untreated UNTREATED]
#                      [--window WINDOW] [--chisq_cut CHISQ_CUT]
#                      [--mindepth MINDEPTH] [--mincount MINCOUNT]
#                      [--metric METRIC] [--mincorrdistance MINCORRDISTANCE]
#                      [--mincoverage MINCOVERAGE] [--highbg_rate HIGHBG_RATE]
#                      [--highbg_corr HIGHBG_CORR] [--ignorents IGNORENTS]
#                      [--molsize MOLSIZE] [--undersample UNDERSAMPLE]
#                      [--writematrixfile WRITEMATRIXFILE]
#                      inputFile outputFile
# 
# Compute correlations from parsed mutations
# 
# positional arguments:
#   inputFile             Path to mutation string file (can be new or old
#                         ShapeMapper format)
#   outputFile            Path for correlation output file
# 
# optional arguments:
#   -h, --help            show this help message and exit
#   --fasta FASTA         Path to fasta sequence file
#   --untreated UNTREATED
#                         Path to untreated (bg) mutation file. Used to remove
#                         high bg positions and bg correlations
#   --window WINDOW       Nt window over which to compute correlations (default
#                         = 1)
#   --chisq_cut CHISQ_CUT
#                         Set chisq cutoff (default = 20)
#   --mindepth MINDEPTH   Minimum pairwise read depth allowed for calculating
#                         correlations (default = 10000)
#   --mincount MINCOUNT   Minimum required count in contigency table (default =
#                         50). Nt pairs with fewer than this number of
#                         comutations are ignored
#   --metric METRIC       Metric to use for computing correlations. options are
#                         chi/g/apc (Chi, G-test, or APC corrected G-test).
#                         (default = apc)
#   --mincorrdistance MINCORRDISTANCE
#                         Minimum distance allowed between correlations
#                         (default=5)
#   --mincoverage MINCOVERAGE
#                         Quality filter reads by requiring a minimum number of
#                         positional matches to reference sequence. This
#                         parameter can be set as a fraction of the total
#                         molecule length (i.e. if 0.8 is passed, reads will be
#                         required to have at least 0.8*len(fasta) valid
#                         matches)/ Alternatively, an integer value can be
#                         passed (i.e. if 150 is passed, reads will be required
#                         to have at least 150 valid matches). By default, this
#                         filter is disabled.
#   --highbg_rate HIGHBG_RATE
#                         Ignore nts with bg reactivity above this value
#                         (default = 0.02). Value is multipled by window (so
#                         default=0.06 for window=3)
#   --highbg_corr HIGHBG_CORR
#                         Ignore nt pairs correlated in the bg sample, with
#                         correlation determined via this significance value
#                         (default=10.83 --> P=1e-3)
#   --ignorents IGNORENTS
#                         A list of comma-separated (1-indexed) nts to ignore
#                         (e.g. 10,12,35)
#   --molsize MOLSIZE     Size of molecule arrays (default = 1000). Value must
#                         be larger than max read index. Only used if fasta file
#                         not provided.
#   --undersample UNDERSAMPLE
#                         Randomly undersample specified number of reads from
#                         inputFile (default=-1 [disabled]).
#   --writematrixfile WRITEMATRIXFILE
#                         Write mutation matrices to file (provide prefix)
