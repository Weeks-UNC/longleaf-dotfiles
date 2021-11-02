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
    sb_params = " ".join([f"--{kw}={params[kw]}" for kw in params.keys()])
    process = f"{sb_prefix} {sb_params} {sb_command}"
    print(f"{process}\n")
    sbatch_response = subprocess.getoutput(process)
    print(sbatch_response)

    job_id = sbatch_response.split(' ')[-1].strip()
    return job_id


def shapemapper(s, m, u, fa, input_type="folders", dep=None):
    command = "~/shapemapper-2.1.5/shapemapper "
    command += f"--target {fa} "
    command += f"--name {s} "
    input_types = ["folders", "flashed", "deduped"]
    valid_input_type = (input_type in input_types)
    assert valid_input_type, f"input_type not in accepted list: {input_types}"
    for i, sample in enumerate([m, u]):
        command += ["--modified ", "--untreated "][i]
        if input_type == "folders":
            command += f"--folders Sample_{sample} "
        elif input_type == "flashed":
            command += f"--U Sample_{sample}/out.extendedFrags.fastq "
        elif input_type == "deduped":
            command += f"--U Sample_{sample}/combined_trimmed_deduped.fastq "
    command += "--amplicon --output-parsed-mutations --per-read-histograms --overwrite"
    params = {"mem": "4g",
              "time": "10:00:00",
              "job-name": "shapemapper",
              "output": f"sbatch_out/{s}/sm_%A.out",
              "ntasks": "6",
              "nodes": "1"}
    return sbatch(command, params, dep)


def ringmapper(s, fa, t, dep=None):
    command = f"~/RingMapper/ringmapper.py "
    command += f"--fasta {fa} "
    command += f"--untreated {smo}/{s}_Untreated_{t}_parsed.mut "
    command += f"{smo}/{s}_Modified_{t}_parsed.mut "
    command += f"{rmo}/{s}_{t}_rings.txt"
    params = {"mem": "4g",
              "time": "1:00:00",
              "job-name": f"ringmapper-{s}",
              "output": f"sbatch_out/{s}/rm_%A.out"}
    return sbatch(command, params, dep)


def pairmapper(s, t, dms=True, dep=None):
    command = "pairmapper.py "
    command += f"--profile {smo}/{s}_{t}_profile.txt "
    command += f"--untreated_parsed {smo}/{s}_Untreated_{t}_parsed.mut "
    command += f"--modified_parsed {smo}/{s}_Modified_{t}_parsed.mut "
    command += f"--out {pmo}/{s}_{t} --override_qualcheck "
    if not dms:
        command += "--notDMS"
    params = {"job-name": f"pairmapper-{s}",
              "output": f"sbatch_out/{s}/pm_%A.out",
              "mem": "4g",
              "time": "1:00:00"}
    return sbatch(command, params, dep)


def arcplot(s, t, ct, data, dms=True, dep=None):
    command = "arcPlot.py "
    command += f"--ct {ct} "
    if dms:
        command += f"--dmsprofile {smo}/{s}_{t}.shape"
    else:
        command += f"--profile {smo}/{s}_{t}.shape "
    if data == "rings":
        command += f"--ringsig {rmo}/{s}_{t}_rings.txt "
        command += f"{apo}/{s}_{t}_rings.pdf"
    if data == "pairs":
        command += f"--pairmap {pmo}/{s}_{t}_pairmap.txt,all "
        command += f"{apo}/{s}_{t}_pairmap.pdf"
    elif data == "allcorrs":
        command += f"--ringsig {pmo}/{s}_{t}_allcorrs.txt"
        command += f"{apo}/{s}_{t}_allcorrs.pdf"
    params = {"job-name": f"arcplot-{s}-{data}",
              "output": f"sbatch_out/{s}/ap_{data}_%A.out"}
    return sbatch(command, params, dep)


def dancemapper_sub1M_fit(s, t, dep=None):
    command = "python ~/DanceMapper/DanceMapper.py "
    command += f"--profile {smo}/{s}_{t}_profile.txt "
    command += f"--modified_parsed {smo}/{s}_Modified_{t}_parsed.mut "
    command += f"--undersample 1000000 --fit --maxcomponents 3 "
    command += f"--outputprefix {dmo}/{s}_{t}"
    params = {"job-name": "dancemapper",
              "output": f"sbatch_out/{s}/dm_fit_%A.out",
              "time": "7-00:00:00",
              "mem": "10g"}
    return sbatch(command, params, dep)


def dancemapper_read_rings_pairs(s, t, dms=True, dep=None):
    command = "python ~/DanceMapper/DanceMapper.py "
    command += f"--profile {smo}/{s}_{t}_profile.txt "
    command += f"--modified_parsed {smo}/{s}_Modified_{t}_parsed.mut "
    command += f"--untreated_parsed {smo}/{s}_Untreated_{t}_parsed.mut "
    if not dms:
        command += "--notDMS "
    command += f"--readfromfile {dmo}/{s}_{t}.bm "
    command += f"--ring --pairmap"
    params = {"job-name": f"dancemapper_{s}",
              "output": f"sbatch_out/{s}/dm_corrs_%A.out",
              "time": "1-00:00:00",
              "mem": "30g"}
    return sbatch(command, params, dep)


def foldclusters(s, t, dms=True, dep=None):
    command = "python ~/DanceMapper/foldClusters.py "
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
    prs.add_argument("fa", type=str, help="location of fasta file")
    prs.add_argument("--ct", type=str, help="location of ct file")
    prs.add_argument("--dms", action="store_true", help="Is this DMS?")
    prs.add_argument("--input", type=str, help="folders, flashed, or deduped")
    args = prs.parse_args()
    return args


def main(s, m, u, fa, input="folders", ct=None, dms=False):
    for dir in ["sbatch_out", f"sbatch_out/{s}", smo, rmo, pmo, apo, dmo, fco]:
        try:
            os.mkdir(dir)
        except FileExistsError:
            pass
    t = fa[:-3]
    smid = shapemapper(s, m, u, fa, input)
    rmid = ringmapper(s, fa, t, smid)
    _ = arcplot(s, t, ct, "rings", dms, rmid)
    pmid = pairmapper(s, t, dms, smid)
    _ = arcplot(s, t, ct, "pairs", dms, pmid)
    _ = arcplot(s, t, ct, "allcorrs", dms, pmid)
    dmid = dancemapper_sub1M_fit(s, t, smid)
    dm2id = dancemapper_read_rings_pairs(s, t, dms, dmid)
    foldclusters(s, t, dms, dm2id)


if __name__ == "__main__":
    main(**vars(parse_args()))