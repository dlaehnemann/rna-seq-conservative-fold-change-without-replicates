rule kallisto_quant_to_gfold_input:
    input:
        kallisto_folder=get_kallisto_output_folder,
        transcripts_annotation=get_transcripts_annotation,
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
        baseline=expand(
            "results/gfold_input/{sample_unit_baseline}.tsv",
            sample_unit_baseline=lookup(
                within=config, dpath="gfold/contrasts/{contrast}/baseline"
            ),
        ),
        changed=expand(
            "results/gfold_input/{sample_unit_changed}.tsv",
            sample_unit_changed=lookup(
                within=config, dpath="gfold/contrasts/{contrast}/changed"
            ),
        ),
    output:
        gfold="results/gfold/{contrast}.tsv",
    log:
        "logs/gfold/{contrast}.log",
    conda:
        "../envs/gfold.yaml"
    params:
        baseline=lambda wc, input: ",".join(
            [path.splitext(b)[0] for b in input.baseline]
        ),
        ext=lambda wc, input: path.splitext(input.baseline[0])[1],
        changed=lambda wc, input: ",".join([path.splitext(b)[0] for b in input.changed]),
    shell:
        "( gfold diff "
        "    -s1 {params.baseline} "
        "    -s2 {params.changed} "
        "    -suf {params.ext} "
        "    -norm DESeq "
        "    -o {output.gfold}"
        ") 2>{log}"


rule clean_and_sort_gfold:
    input:
        gfold="results/gfold/{contrast}.tsv",
        transcripts_annotation=get_transcripts_annotation,
    output:
        cleaned="results/gfold/{contrast}.cleaned_and_sorted.tsv",
        all_tested_annotated="results/gfold/{contrast}.all_tested_annotated.tsv",
    log:
        "logs/gfold/{contrast}.cleaned_and_sorted.log",
    conda:
        "../envs/tidyverse.yaml"
    params:
        gfold_0_01_cutoff=config["gfold"]["gfold_0_01_cutoff"],
    script:
        "../scripts/clean_and_sort_gfold.R"


rule gfold_datavzrd:
    input:
        config=workflow.source_path("../resources/datavzrd/gfold_template.yaml"),
        # files required for rendering the given configs
        gfold_table="results/gfold/{contrast}.cleaned_and_sorted.tsv",
    output:
        report(
            directory("results/datavzrd-reports/gfold/{contrast}"),
            htmlindex="index.html",
            caption="../report/gfold_table.rst",
            category="gfold",
            patterns=["index.html"],
            labels={"contrast": "{contrast}"},
        ),
        config="results/datavzrd/gfold/{contrast}.yaml",
    log:
        "logs/datavzrd-reports/gfold/{contrast}.log",
    wrapper:
        "v5.9.0/utils/datavzrd"
