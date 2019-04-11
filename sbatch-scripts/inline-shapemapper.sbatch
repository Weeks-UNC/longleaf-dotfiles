#!/usr/bin/env bash

sbatch -t 60 \
--partition=general \
--ntasks=6 \
--nodes=1 \
-o output-file.out \
--wrap="~/shapemapper-2.1.3/shapemapper \
--target reference.fa \
--name 'experiment-name' \
--overwrite \
--min-depth 4000 \
--modified \
--folder plus \
--untreated \
--folder minus \
--output-classified"
