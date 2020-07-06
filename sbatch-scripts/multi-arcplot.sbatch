#!/usr/bin/env bash
#SBATCH --job-name=arcplot
#SBATCH --output=arcplot_%A_%a.out
#SBATCH --array=0-3
#SBATCH --time=10:00
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
"arcPlot.py --ct RMRP.ct --ringsig 2API-SSII-RMRP.corrs --profile 2API-SSII_RMRP.shape 2API-SSII-RMRP-ringsig.pdf"
"arcPlot.py --ct RMRP.ct --ringsig DMS-SSII-RMRP.corrs --profile DMS-SSII_RMRP.shape DMS-SSII-RMRP-ringsig.pdf"
"arcPlot.py --ct RMRP.ct --pairmap 2API-SSII-RMRP-pairmap.txt --profile 2API-SSII_RMRP.shape 2API-SSII-RMRP-pairmap.pdf"
"arcPlot.py --ct RMRP.ct --pairmap DMS-SSII-RMRP-pairmap.txt --profile DMS-SSII_RMRP.shape DMS-SSII-RMRP-pairmap.pdf"
)

eval ${tasks[$SLURM_ARRAY_TASK_ID]}

# Adds a table of SLURM jobs stats: pending time, job time, CPU and memory usage. This will be at the end of the SBATCH output file.
sacct -j $SLURM_JOB_ID --format='JobID, submit, start, elapsed, cputime, MaxRSS'

# usage: arcPlot.py [-h] [--ct CT] [--fasta FASTA] [--refct REFCT]
#                   [--probability PROBABILITY] [--ringz RINGZ]
#                   [--ringsig RINGSIG] [--pairmap PAIRMAP]
#                   [--compare_pairmap COMPARE_PAIRMAP] [--ntshape NTSHAPE]
#                   [--profile PROFILE] [--dmsprofile DMSPROFILE] [--bottom]
#                   [--title TITLE] [--showGrid] [--bound BOUND] [--filternc]
#                   outputPDF
# 
# positional arguments:
#   outputPDF             Name of the output PDF graphic
# 
# optional arguments:
#   -h, --help            show this help message and exit
#   --ct CT               Base CT file to plot. By default, the first (0th)
#                         structure is plotted. Alternative structures can be
#                         selected by passing ,# after the CT file name (e.g.
#                         --ct ctfile.ct,3)
#   --fasta FASTA         Fasta sequence file
#   --refct REFCT         Reference CT to compare base ct against. By default
#                         the first (0th) structure is plotted. Alternative
#                         structures can be selected by passing ,# after the CT
#                         file name (e.g. --refct ctfile.ct,3)
#   --probability PROBABILITY
#                         Pairing probability file in dotplot format. By
#                         default, arcs are drawn for the following probability
#                         intervals: [0.03,0.1], [0.1,0.3], [0.3,0.8],
#                         [0.8,1.0]. These intervals can be modified by passing
#                         thresholds as comma-separated values. For example,
#                         --prob file.dp,0.03,0.1,0.3,0.8,1.0 specifies the
#                         default intervals. At most 4 intervals can be plotted,
#                         but fewer intervals are allowed (e.g. --prob
#                         file.dp,0.1,0.3,0.8,1.0 will plot 3 intervals).
#   --ringz RINGZ         Plot Z-scores from ringmapper correlation file.
#                         Default color thresholds are Z=1 and Z=5. Can be
#                         modified by passing thresholds as comma-separated
#                         values (e.g. --corrz corrs.txt,1,5)
#   --ringsig RINGSIG     Plot statistical significance from ringmapper file.
#                         Default color thresholds are [20,500]. Can be modified
#                         by passing thresholds as comma-separated values (e.g.
#                         --corrsig corrs.txt,20,500)
#   --pairmap PAIRMAP     Plot pairmap signals from pairmap file. By default
#                         plot principal & minor correlations. Can plot all
#                         complementary correlations by passing ,all (e.g.
#                         --pairmap pairmap.txt,all)
#   --compare_pairmap COMPARE_PAIRMAP
#                         Plot pairmap signals from second pairmap file. By
#                         default plot principal & minor correlations. Can plot
#                         all complementary correlations by passing ,all (e.g.
#                         --compare_pairmap pairmap.txt,all)
#   --ntshape NTSHAPE     Color nucs by shape reactivty in provided shape/map
#                         file
#   --profile PROFILE     Plot reactivity profile on top from shape/map file
#   --dmsprofile DMSPROFILE
#                         Normalize and plot DMS reactivity from profile file
#   --bottom              Plot arcs on the bottom
#   --title TITLE         Figure title
#   --showGrid            plot a grid on axis ticks
#   --bound BOUND         comma separated bounds of region to plot (e.g. --bound
#                         511,796)
#   --filternc            filter out non-canonical pairs in ct
