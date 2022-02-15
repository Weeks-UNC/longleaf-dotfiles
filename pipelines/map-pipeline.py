#!/usr/bin/env python
import subprocess
import argparse
import os

smo = "shapemapper_out"
rmo = "ringmapper_out"
pmo = "pairmapper_out"
apo = "arcplot_out"
dmo = "dancemapper_out"
fco = "foldclusters_out"


def sbatch(command, params, dep=None):
    if dep is not None:
        params["dependency"] = f"afterok:{dep}"
        params["kill-on-invalid-dep"] = "yes"
    sb_prefix = "sbatch"
    sb_command = f"--wrap='source activate py2-MaP; {command}'"
    sb_params = " ".join([f"--{k}={v}" for k, v in params.items()])
    process = f"{sb_prefix} {sb_params} {sb_command}"
    print(f"{process}\n")
    sbatch_response = subprocess.getoutput(process)
    print(sbatch_response)

    job_id = sbatch_response.split(' ')[-1].strip()
    return job_id

def stringify_params(params):
    return " ".join([f"--{k} {v}".strip() for k, v in params.items])

def shapemapper(s, m, u, fas, input_type="folders", dep=None, amplicon=False,
                sm_params={}):
    command = "~/shapemapper-2.1.5/shapemapper "
    command += f"{stringify_params(sm_params)} "
    command += f"--target {' '.join(fas)} "
    command += f"--name {s} "
    input_types = ["folders", "flashed", "deduped"]
    valid_input_type = (input_type in input_types)
    assert valid_input_type, f"input_type not in accepted list: {input_types}"
    if input_type == "folders":
        command += f"--modified --folder Sample_{m} "
        command += f"--untreated --folder Sample_{u} "
    elif input_type == "flashed":
        command += f"--modified --U Sample_{m}/out.extendedFrags.fastq "
        command += f"--untreated --U Sample_{u}/out.extendedFrags.fastq "
    elif input_type == "deduped":
        command += f"--modified --U Sample_{m}/combined_trimmed_deduped.fastq "
        command += f"--untreated --U Sample_{u}/out.extendedFrags.fastq "
    if amplicon:
        command += "--amplicon "
    else:
        command += "--random-primer-len 9 "
    command += "--output-parsed-mutations "
    command += "--per-read-histograms "
    command += "--overwrite"
    params = {"mem": "4g",
              "time": "10:00:00",
              "job-name": "shapemapper",
              "output": f"sbatch_out/{s}/sm_%A.out",
              "ntasks": "6",
              "nodes": "1"}
    return sbatch(command, params, dep)


def ringmapper(s, fa, t, dep=None, rm_params={}):
    command = f"~/RingMapper/ringmapper.py "
    command += f"{stringify_params(rm_params)} "
    command += f"--fasta {fa} "
    command += f"--untreated {smo}/{s}_Untreated_{t}_parsed.mut "
    command += f"{smo}/{s}_Modified_{t}_parsed.mut "
    command += f"{rmo}/{s}_{t}_rings.txt"
    params = {"mem": "4g",
              "time": "3:00:00",
              "job-name": f"ringmapper-{s}",
              "output": f"sbatch_out/{s}/rm_%A.out"}
    return sbatch(command, params, dep)


def pairmapper(s, t, dms=True, dep=None, pm_params={}):
    command = "pairmapper.py "
    command += f"{stringify_params(pm_params)} "
    command += f"--profile {smo}/{s}_{t}_profile.txt "
    command += f"--untreated_parsed {smo}/{s}_Untreated_{t}_parsed.mut "
    command += f"--modified_parsed {smo}/{s}_Modified_{t}_parsed.mut "
    command += f"--out {pmo}/{s}_{t} --override_qualcheck "
    if not dms:
        command += "--notDMS"
    params = {"job-name": f"pairmapper-{s}",
              "output": f"sbatch_out/{s}/pm_%A.out",
              "mem": "4g",
              "time": "3:00:00"}
    return sbatch(command, params, dep)


def arcplot(s, t, ct, data, dms=True, dep=None):
    command = "arcPlot.py "
    command += f"--ct {ct} "
    if dms:
        command += f"--dmsprofile {smo}/{s}_{t}.shape "
    else:
        command += f"--profile {smo}/{s}_{t}.shape "
    if data == "rings":
        command += f"--ringsig {rmo}/{s}_{t}_rings.txt "
        command += f"{apo}/{s}_{t}_rings.pdf"
    if data == "pairs":
        command += f"--pairmap {pmo}/{s}_{t}-pairmap.txt,all "
        command += f"{apo}/{s}_{t}_pairmap.pdf"
    elif data == "allcorrs":
        command += f"--ringsig {pmo}/{s}_{t}-allcorrs.txt "
        command += f"{apo}/{s}_{t}_allcorrs.pdf"
    params = {"job-name": f"arcplot-{s}-{data}",
              "output": f"sbatch_out/{s}/ap_{data}_%A.out"}
    return sbatch(command, params, dep)


def dancemapper_sub1M_fit(s, t, dep=None, dm1_params={}):
    command = "python ~/DanceMapper/DanceMapper.py "
    command += f"{stringify_params(dm1_params)} "
    command += f"--profile {smo}/{s}_{t}_profile.txt "
    command += f"--modified_parsed {smo}/{s}_Modified_{t}_parsed.mut "
    command += f"--undersample 1000000 --fit --maxcomponents 3 "
    command += f"--outputprefix {dmo}/{s}_{t}"
    params = {"job-name": "dancemapper",
              "output": f"sbatch_out/{s}/dm_fit_%A.out",
              "time": "7-00:00:00",
              "mem": "10g"}
    return sbatch(command, params, dep)


def dancemapper_read_rings_pairs(s, t, dms=True, dep=None, dm2_params={}):
    command = "python ~/DanceMapper/DanceMapper.py "
    command += f"{stringify_params(dm2_params)} "
    command += f"--profile {smo}/{s}_{t}_profile.txt "
    command += f"--modified_parsed {smo}/{s}_Modified_{t}_parsed.mut "
    command += f"--untreated_parsed {smo}/{s}_Untreated_{t}_parsed.mut "
    command += f"--outputprefix {dmo}/{s}_{t} "
    if not dms:
        command += "--notDMS "
    command += f"--readfromfile {dmo}/{s}_{t}.bm "
    command += f"--ring --pairmap"
    params = {"job-name": f"dancemapper_{s}",
              "output": f"sbatch_out/{s}/dm_corrs_%A.out",
              "time": "3-00:00:00",
              "mem": "30g"}
    return sbatch(command, params, dep)


def foldclusters(s, t, dms=True, dep=None, fc_params={}):
    command = "python ~/DanceMapper/foldClusters.py "
    command += f"{stringify_params(fc_params)} "
    command += f"--bp {dmo}/{s}_{t} "
    command += f"--prob --pk "
    if not dms:
        command += f"--notDMS "
    command += f"{dmo}/{s}_{t}-reactivities.txt {fco}/{s}-{t}"
    params = {"job-name": f"foldclusters_{s}",
              "output": f"sbatch_out/{s}/fc_%A.out",
              "time": "1:00:00"}
    return sbatch(command, params, dep)


def parse_args():
    prs = argparse.ArgumentParser()
    prs.add_argument("s", type=str, help="Name for outputs")
    prs.add_argument("m", type=str, help="Sample # for fastqs")
    prs.add_argument("u", type=str, help="Sample # for fastqs")
    prs.add_argument("--fas", type=str, nargs='+',
                     help="location of fasta file")
    prs.add_argument("--cts", type=str, nargs='+', help="location of ct file")
    prs.add_argument("--dms", action="store_true", help="Is this DMS?")
    prs.add_argument("--input", type=str, help="folders, flashed, or deduped")
    prs.add_argument("--steps", type=int, nargs="+", default=[1, 2, 3, 4, 5, 6],
                     help=("1=Shapemapper, 2=RingMapper, 3=PairMapper, "
                           "4=Dance-fit, 5=Dance-corrs, 6=foldClusters"))
    prs.add_argument("--amplicon", action="store_true", default=False,
                     help="use amplicon flag with Shapemapper2")
    prs.add_argument("--sm_params", type=str, nargs="+",
                     help="custom parameters for Shapemapper")
    prs.add_argument("--rm_params", type=str, nargs="+",
                     help="custom parameters for Ringmapper")
    prs.add_argument("--pm_params", type=str, nargs="+",
                     help="custom parameters for Pairmapper")
    prs.add_argument("--dm1_params", type=str, nargs="+",
                     help="custom parameters for Dancemapper1")
    prs.add_argument("--dm2_params", type=str, nargs="+",
                     help="custom parameters for Dancemapper2")
    prs.add_argument("--fc_params", type=str, nargs="+",
                     help="custom parameters for FoldClusters")
    args = prs.parse_args()
    for arg in ["sm", "rm", "pm", "dm1", "dm2", "fc"]:
        params = args[f"{arg}_params"]
        k_v_pairs = [pair.split("=") for pair in params]
        args[f"{arg}_params"] = {k:v for k, v in k_v_pairs}
    return args


def main(s, m, u, fas, input="folders", cts=None, dms=False, amplicon=False,
         steps=[1, 2, 3, 4, 5, 6], sm_params={}, rm_params={}, pm_params={},
         dm1_params={}, dm2_params={}, fc_params={}):
    for dir in ["sbatch_out", f"sbatch_out/{s}", smo, rmo, pmo, apo, dmo, fco]:
        try:
            os.mkdir(dir)
        except FileExistsError:
            pass
    smid, rmid, pmid, dmid, dm2id = None, None, None, None, None
    if 1 in steps:
        smid = shapemapper(s, m, u, fas, input, None, amplicon, sm_params)
    for fa, ct in zip(fas, cts):
        t = fa[:-3]
        if 2 in steps:
            rmid = ringmapper(s, fa, t, smid, rm_params)
            _ = arcplot(s, t, ct, "rings", dms, rmid)
        if 3 in steps:
            pmid = pairmapper(s, t, dms, smid, pm_params)
            _ = arcplot(s, t, ct, "pairs", dms, pmid)
            _ = arcplot(s, t, ct, "allcorrs", dms, pmid)
        if 4 in steps:
            dmid = dancemapper_sub1M_fit(s, t, smid, dm1_params)
        if 5 in steps:
            dm2id = dancemapper_read_rings_pairs(s, t, dms, dmid, dm2_params)
        if 6 in steps:
            foldclusters(s, t, dms, dm2id, fc_params)


if __name__ == "__main__":
    main(**vars(parse_args()))
