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
        "    -norm DESeq "
        "    -o {output.gfold}"
        ") 2>{log}"


rule clean_and_sort_gfold:
    input:
        gfold="results/gfold/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.tsv",
        transcripts_annotation=get_transcripts_annotation,
    output:
        cleaned="results/gfold/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.cleaned_and_sorted.tsv",
        all_tested_annotated="results/gfold/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.all_tested_annotated.tsv",
    log:
        "logs/gfold/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.cleaned_and_sorted.log",
    conda:
        "../envs/tidyverse.yaml"
    script:
        "../scripts/clean_and_sort_gfold.R"


rule render_datavzrd_config_gfold:
    input:
        template=workflow.source_path("../resources/datavzrd/gfold_template.yaml"),
        gfold_table="results/gfold/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.cleaned_and_sorted.tsv",
    output:
        "results/datavzrd/gfold/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.yaml",
    log:
        "logs/datavzrd/gfold/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.yte_rendering.log",
    template_engine:
        "yte"


rule gfold_datavzrd:
    input:
        config="results/datavzrd/gfold/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.yaml",
        # files required for rendering the given configs
        gfold_table="results/gfold/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.cleaned_and_sorted.tsv",
    output:
        report(
            directory(
                "results/datavzrd-reports/gfold/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}"
            ),
            htmlindex="index.html",
            caption="../report/gfold_table.rst",
            category="gfold",
            patterns=["index.html"],
            labels={
                "contrast": "{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}"
            },
        ),
    log:
        "logs/datavzrd-reports/gfold/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.log",
    wrapper:
        "v2.12.0/utils/datavzrd"
