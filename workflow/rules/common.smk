import yaml


# final output function


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


# helper / setup functions

## bioconductor species package setup via config


def get_bioc_species_name():
    first_letter = config["resources"]["ref"]["species"][0]
    subspecies = config["resources"]["ref"]["species"].split("_")[1]
    return first_letter + subspecies


def get_bioc_species_pkg():
    """Get the package bioconductor package name for the the species in config.yaml"""
    species_letters = get_bioc_species_name()[0:2].capitalize()
    return "org.{species}.eg.db".format(species=species_letters)


bioc_species_pkg = get_bioc_species_pkg()


def render_enrichment_env():
    species_pkg = f"bioconductor-{get_bioc_species_pkg()}"
    with open(workflow.source_path("../envs/enrichment.yaml")) as f:
        env = yaml.load(f, Loader=yaml.SafeLoader)
    env["dependencies"].append(species_pkg)
    env_path = Path("resources/envs/enrichment.yaml")
    env_path.parent.mkdir(parents=True, exist_ok=True)
    with open(env_path, "w") as f:
        yaml.dump(env, f)
    return env_path.absolute()


enrichment_env = render_enrichment_env()


## input functions


def get_kallisto_output_folder(wildcards):
    return f"{config['gfold']['kallisto_path']}/{wildcards.sample}-{wildcards.unit}"


def get_spia_db(wildcards):
    return config["gfold"]["spia_db"]


def get_transcripts_annotation(wildcards):
    return f"{config['gfold']['transcripts_annotation']}"
