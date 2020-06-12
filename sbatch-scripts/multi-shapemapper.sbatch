#!/usr/bin/env bash
#SBATCH --job-name=shapemapper
#SBATCH --output=shapemapper_%A_%a.out
#SBATCH --array=0-15
#SBATCH --time=1:00:00
#SBATCH --ntasks=6
#SBATCH --nodes=1
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
"shapemapper --target 7SK.fa --name 'NAI' --modified --folder Sample_1 --untreated --folder Sample_4 --amplicon --output-parsed-mutations --out 7SK_out --temp 7SK_temp"
"shapemapper --target 7SK.fa --name '2API' --modified --folder Sample_2 --untreated --folder Sample_4 --amplicon --output-parsed-mutations --out 7SK_out --temp 7SK_temp"
"shapemapper --target 7SK.fa --name 'CDI' --modified --folder Sample_3 --untreated --folder Sample_4 --amplicon --output-parsed-mutations --out 7SK_out --temp 7SK_temp"
"shapemapper --target 7SK.fa --name 'DMS' --modified --folder Sample_5 --untreated --folder Sample_6 --amplicon --output-parsed-mutations --out 7SK_out --temp 7SK_temp"
"shapemapper --target RNaseP.fa --name 'NAI-RNaseP' --modified --folder Sample_7 --untreated --folder Sample_10 --amplicon --output-parsed-mutations --out RNaseP_out --temp RNaseP_temp"
"shapemapper --target RNaseP.fa --name '2API-RNaseP' --modified --folder Sample_8 --untreated --folder Sample_10 --amplicon --output-parsed-mutations --out RNaseP_out --temp RNaseP_temp"
"shapemapper --target RNaseP.fa --name 'CDI-RNaseP' --modified --folder Sample_9 --untreated --folder Sample_10 --amplicon --output-parsed-mutations --out RNaseP_out --temp RNaseP_temp"
"shapemapper --target RNaseP.fa --name 'DMS-RNaseP' --modified --folder Sample_11 --untreated --folder Sample_12 --amplicon --output-parsed-mutations --out RNaseP_out --temp RNaseP_temp"
"shapemapper --target RMRP.fa --name 'NAI-SSII' --modified --folder Sample_13 --untreated --folder Sample_18 --amplicon --output-parsed-mutations --out RMRP_out --temp RMRP_temp"
"shapemapper --target RMRP.fa --name '2API-SSII' --modified --folder Sample_14 --untreated --folder Sample_18 --amplicon --output-parsed-mutations --out RMRP_out --temp RMRP_temp"
"shapemapper --target RMRP.fa --name 'CDI-SSII' --modified --folder Sample_15 --untreated --folder Sample_18 --amplicon --output-parsed-mutations --out RMRP_out --temp RMRP_temp"
"shapemapper --target RMRP.fa --name 'DMS-SSII' --modified --folder Sample_17 --untreated --folder Sample_18 --amplicon --output-parsed-mutations --out RMRP_out --temp RMRP_temp"
"shapemapper --target RMRP.fa --name 'NAI-MRT' --modified --folder Sample_19 --untreated --folder Sample_22 --amplicon --output-parsed-mutations --out RMRP_out --temp RMRP_temp"
"shapemapper --target RMRP.fa --name '2API-MRT' --modified --folder Sample_20 --untreated --folder Sample_22 --amplicon --output-parsed-mutations --out RMRP_out --temp RMRP_temp"
"shapemapper --target RMRP.fa --name 'CDI-MRT' --modified --folder Sample_21 --untreated --folder Sample_22 --amplicon --output-parsed-mutations --out RMRP_out --temp RMRP_temp"
"shapemapper --target RMRP.fa --name 'DMS-MRT' --modified --folder Sample_23 --untreated --folder Sample_24 --amplicon --output-parsed-mutations --out RMRP_out --temp RMRP_temp"
)
eval ${tasks[$SLURM_ARRAY_TASK_ID]}


# Adds a table of SLURM jobs stats: pending time, job time, CPU and memory usage. This will be at the end of the SBATCH output file.
sacct -j $SLURM_JOB_ID --format='JobID, submit, start, elapsed, CPUTime, MaxRSS'

# Usage
# -----
# 
# shapemapper <parameters> <inputs> | --version | --help
# 
# ### Inputs
# 
# --<sample>   [--folder <fastq_folder> | --R1 <file_R1.fastq> --R2 <file_R2.fastq> |
#               --unpaired-folder <fastq_folder> | --U <file.fastq> ]
#              Samples must be from the following:
#                "--modified", "--untreated/--unmodified", "--denatured"
#              Folder or files may be specified, but not both.
# 
#              Note: reads from separate instrument barcode indices are expected to
#              be in separate files, and should not contain index sequences.
# 
# --correct-seq [--folder <fastq_folder> | --R1 <file_R1.fastq> --R2 <file_R2.fastq> |
#                --unpaired-folder <fastq_folder> | --U <file.fastq> ]
#               Files to be used to identify sequence variants prior to SHAPE analysis.
#               If a dedicated sequencing experiment is available, use those samples.
#               In a typical MaP experiment, it is recommended to use the least-mutated
#               sample (untreated).
# 
# ### Parameters
# 
# Required:
# 
# --target     FASTA file or list of files (.fa or .fasta) containing one or more
#              target DNA sequences ('T' not 'U'). Lowercase positions will be
#              excluded from reactivity profile, and should be used to indicate
#              primer-binding sites if using directed primers. If multiple primer
#              pairs were used, provide the primer sequences in a separate file with
#              '--primers' (see below).
# 
# Optional:
# 
# --name       Unique name to prefix all output filenames. Highly recommended if
#              running multiple ShapeMapper instances from the same folder.
# 
# --out        Output folder. Default="shapemapper_out"
# 
# --temp       Temporary file folder. Default="shapemapper_temp"
# 
# --overwrite  Overwrite existing files in output and temporary file folders
#              without warning. Default=False
# 
# --log        Location of output log file. Default="<name>_shapemapper_log.txt"
# 
# --verbose    Display full commands for each executed process, and display more
#              process output messages in the event of an error. Default=False
# 
# --random-primer-len <n>
#              Length of random primers used (if any). Mutations within (length+1)
#              of the 3-prime end of a read will be excluded, as will read depths
#              over this region. Unused if '--amplicon' and/or '--primers' are
#              provided. Default=0
# 
# --amplicon   Require reads to align near expected primer pair locations, and
#              intelligently trim primer sites. If a single pair of primers on
#              the ends of the RNA sequence is used, simply set primer sequences
#              to lowercase in the '--target' fasta file. If multiple pairs or
#              internal locations are needed, specify primers with a '--primers'
#              file.
# 
#      --primers <primers_file>
#              Amplicon primer pair sequences. Each line should contain a pair of
#              primer sequences: the forward primer first followed by the reverse
#              primer, separated by whitespace. To specify primers for multiple RNAs,
#              add a line with each RNA name preceded by '>' before each group of
#              primer pairs. RNA names must match those in any provided .fa files.
# 
#      --max-primer-offset <n>
#              If '--amplicon' and/or '--primers' used, require read ends to align to
#              within +/- this many nucleotides of expected amplicon primer pairs.
#              Default=10
# 
# --star-aligner
#              Use STAR instead of Bowtie2 for sequence alignment. Recommended for
#              sequences longer than several thousand nucleotides. Default=False
#              Note: STAR slows down considerably in the presence of non-mapping
#              sequences (i.e. if the target fasta files don't contain all the
#              sequences present in the input reads). With current parameters, STAR
#              may also be slightly less sensitive than Bowtie2 (fewer aligned reads).
# 
#      --genomeSAindexNbase <n>
#              Manually set STAR index building parameter. Default=0, indicating that
#              ShapeMapper should recompute this parameter using the formula
#              recommended by the STAR manual.
# 
#      --rerun-on-star-segfault
#              Automatically rerun ShapeMapper analyses that fail due to STAR segfault.
#              The value of '--genomeSAindexNbase' will be replaced with the value of
#              '--rerun-genomeSAindexNbase'. Default=False
# 
#      --rerun-genomeSAindexNbase <n>
#              Default=3
# 
#      --star-shared-index
#              Enable shared memory index. Default=False
# 
# --preserve-order
#              Preserve the order of input reads through all analysis stages. May
#              slow down execution, but can be useful for debugging. Default=False
# 
# --nproc <n>  Number of processors to use for sequence alignment (corresponding
#              to Bowtie2's '-p' parameter and STAR's '--runThreadN' parameter).
#              Default=4
# 
# --max-paired-fragment-length <n>
#              Maximum distance between aligned ends of non-overlapping mate pairs
#              to be merged into a single read (analogous to bowtie2 '--maxins').
#              Default=800
# 
# --min-depth  <n>
#              Minimum effective sequencing depth for including data (threshold must
#              be met for all provided samples). Default=5000
# 
# --max-bg <n>
#              Maximum allowed mutation frequency in untreated sample. Default=0.05
# 
# --min-mapq <n>
#              Minimum aligner-reported mapping quality for included reads. Default=10
#              Note: When using Bowtie2, mutations contribute to lower mapping
#              quality. Therefore, raising this threshold will have the side effect
#              of excluding highly mutated reads.
#              Note: This option does not apply to sequence correction, which uses
#              a threshold of 10 regardless of this option
# 
# --min-qual-to-trim <n>
#              Minimum phred score in initial basecall quality trimming.
#              Default=20
# 
# --window-to-trim <n>
#              Window size in initial basecall quality trimming. Default=5
# 
# --min-length-to-trim
#              Minimum trimmed read length in initial basecall quality trimming.
#              Default=25
# 
# --min-qual-to-count <n>
#              Only count mutations with all basecall quality scores meeting this
#              minimum score (including the immediate upstream and downstream
#              basecalls). This threshold is also used when computing the
#              effective read depth. Default=30
# 
# --indiv-norm Normalize multiple reactivity profiles individually, instead of as a
#              group. Default=False
# 
# --min-seq-depth <n>
#              Minimum sequencing depth for making a sequence correction (with
#              '--correct-seq'). Default=50
# 
# --min-freq <n>
#              Minimum mutation frequency for making a sequence correction (with
#              '--correct-seq'). Default=0.6
# 
# --disable-soft-clipping
#              Disable soft-clipping (i.e. perform end-to-end rather than local
#              alignment). Default=False
#              Note: this does not apply to sequence correction, which uses
#              soft-clipping regardless.
# 
# --right-align-ambig
#              Realign ambiguous deletions/insertions to their rightmost valid position
#              instead of leftmost. Not recommended, since left-realignment produces
#              empirically better reactivity profiles than right-realignment.
#              Default=False
# 
# --min-mutation-separation <n>
#              For two mutations to be treated as distinct, they must be separated by at
#              least this many unchanged reference sequence nucleotides. Otherwise, they
#              will be merged and treated as a single mutation. Does not apply to
#              sequence correction. Default=6
# 
# --output-processed-reads
# --output-aligned-reads
# --output-parsed-mutations
# --output-counted-mutations
#              Produce output files for selected intermediate components. Default=False
# 
# --render-flowchart
#              Render a flowchart (SVG format) in the output folder. This will depict
#              all data processing components and input and output files for the
#              current analysis pipeline. Default=False
# 
# --render-mutations
#              Render pdf files showing detailed read and mutation processing steps
#              for each sample and RNA target, up to '--max-pages'. Primarily a debugging
#              tool, but can be useful to visually inspect individual reads for the
#              presence of pseudogenes.
# 
#      --max-pages <n>
#              Maximum pages to render for '--render-mutations'. Default=100
# 
# --per-read-histograms
#              Output read length and per-read mutation frequency histogram tables in
#              log file.
# 
# --structured-output
#              Output all files in a folder hierarchy matching the pipeline organization.
#              If this option is provided, '--temp' folder will not be used.
#              Default behavior is to generate files and folders in a hierarchy in
#              the temp folder, except for important output files which are
#              generated in the main output folder.
# 
# --serial     Run pipeline components one at a time and write all intermediate files
#              to disk. Useful for debugging, but not generally recommended, as this will
#              use large amounts of disk space. Default=False
# 
# Usage examples
# --------------
# (Note: commandline argument examples only; will not produce output.
#  For a runnable example, execute `run_example.sh`)
# 
# Three-sample experiment, input FASTQ files:
# 
#   shapemapper --name example --target TPP.fa --out TPP_shapemap --amplicon --modified --R1 TPPplus_R1.fastq.gz --R2 TPPplus_R2.fastq.gz --untreated --R1 TPPminus_R1.fastq.gz --R2 TPPminus_R2.fastq.gz --denatured --R1 TPPdenat_R1.fastq.gz --R2 TPPdenat_R2.fastq.gz
# 
# Two-sample experiment, input from folders:
# 
#   shapemapper --name example2 --target TPP.fa --out TPP_shapemap --amplicon --modified --folder TPPplus --untreated --folder TPPminus
# 
# Only generate corrected sequence:
# 
#   shapemapper --name example3 --target TPP.fa --out TPP_mutant --amplicon --correct-seq --folder sequence_variant/A100
# 
# Generate corrected sequence using untreated sample,
# then perform SHAPE-MaP analysis:
# 
#   shapemapper --name example4 --target TPP.fa --out --amplicon TPP_mutant --correct-seq --folder TPPminus --modified --folder TPPplus --untreated --folder TPPminus --denatured --folder TPPdenat
# 
# Multiple RNAs, randomly-primed experiment, STAR aligner:
# 
#   shapemapper --name example5 --target 16S.fa 23S.fa --out ribosome --random-primer-len 9 --star-aligner --modified --folder ribosome_plus --untreated --folder ribosome_minus --denatured --folder ribosome_denat
