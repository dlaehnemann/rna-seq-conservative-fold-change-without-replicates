def final_output(wildcards):
    final_output = []
    for c in config["gfold"]["contrasts"]:
        contrast = config["gfold"]["contrasts"][c]
        final_output.extend(
            [
                f"results/gfold/{contrast['changed']}_vs_{contrast['baseline']}.tsv",
                f"results/datavzrd-reports/gfold/{contrast['changed']}_vs_{contrast['baseline']}",
            ]
        )
        if config["enrichment"]["spia"]["activate_gfold"]:
            final_output.extend(
                [
                    f"results/datavzrd-reports/spia/{contrast['changed']}_vs_{contrast['baseline']}",
                ]
            )
    return final_output


## input functions


def get_kallisto_output_folder(wildcards):
    return f"{config['gfold']['kallisto_path']}/{wildcards.sample}-{wildcards.unit}"


def get_transcripts_annotation(wildcards):
    return f"{config['gfold']['transcripts_annotation']}"
