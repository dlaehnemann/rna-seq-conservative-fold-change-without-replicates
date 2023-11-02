rule kallisto_quant_to_gfold_input:
    input:
        kallisto_folder=get_kallisto_output_folder,
    output:
        gfold_tsv="results/gfold_input/{sample}-{unit}.tsv",
    log:
        "logs/gfold_input/{sample}-{unit}.log",
    conda:
        "../envs/tidyverse.yaml"
    script:
        "../scripts/kallisto_quant_to_gfold_input.R"


rule gfold:
    input:
        baseline="results/gfold_input/{sample_baseline}-{unit_baseline}.tsv",
        changed="results/gfold_input/{sample_changed}-{unit_changed}.tsv",
    output:
        gfold="results/gfold/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.tsv",
    log:
        "logs/gfold/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.log",
    conda:
        "../envs/gfold.yaml"
    params:
        baseline=lambda wc, input: path.splitext(input.baseline)[0],
        ext=lambda wc, input: path.splitext(input.baseline)[1],
        changed=lambda wc, input: path.splitext(input.changed)[0],
    shell:
        "( gfold diff "
        "    -s1 {params.baseline} "
        "    -s2 {params.changed} "
        "    -suf {params.ext} "
        "    -norm NO "
        "    -o {output.gfold}"
        ") 2>{log}"
