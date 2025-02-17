#!/usr/bin/env bash
#SBATCH --job-name=dedupe
#SBATCH --output=sbatch_out/dedupe_%A_%a.out
#SBATCH --array=1-12
#SBATCH --time=1:00:00
#SBATCH --mem=10g


module load bbmap
module load umi_tools

cd Sample_$SLURM_ARRAY_TASK_ID
bbmerge.sh in1=*R1_001.fastq.gz in2=*R2_001.fastq.gz out=out.extendedFrags.fastq outu1=out.unmerged1.fastq outu2=out.unmerged2.fastq
umi_tools extract --extract-method=regex --bc-pattern='(?P<umi_1>.{5}).*(?P<umi_2>.{5})' -I out.extendedFrags.fastq -S combined_trimmed.fastq
dedupe.sh in=combined_trimmed.fastq out=combined_trimmed_deduped.fastq ac=f
