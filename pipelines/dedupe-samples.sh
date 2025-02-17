#!/usr/bin/env bash
#SBATCH --job-name=dedupe
#SBATCH --output=sbatch_out/dedupe_%A_%a.out
#SBATCH --array=1-12
#SBATCH --time=1:00:00
#SBATCH --mem=10g

module purge
module load bbmap
module load umi_tools

cd Sample_$SLURM_ARRAY_TASK_ID

pattern1="*R1_001.fastq.gz"
pattern2="*R2_001.fastq.gz"
fastq1=( $pattern1 )
fastq2=( $pattern2 )
echo ${fastq1[0]} ${fastq2[0]}

bbmerge.sh in1=${fastq1[0]} in2=${fastq2[0]} out=out.extendedFrags.fastq outu1=out.unmerged1.fastq outu2=out.unmerged2.fastq
umi_tools extract --extract-method=regex --bc-pattern='(?P<umi_1>.{5}).*(?P<umi_2>.{5})' -I out.extendedFrags.fastq -S combined_trimmed.fastq
dedupe.sh in=combined_trimmed.fastq out=combined_trimmed_deduped.fastq ac=f
