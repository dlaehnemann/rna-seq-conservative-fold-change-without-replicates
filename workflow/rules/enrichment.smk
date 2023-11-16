import yaml

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


def get_spia_db(wildcards):
    return config["gfold"]["spia_db"]

rule spia:
    input:
        all_tested_annotated="results/gfold/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.all_tested_annotated.tsv",
        spia_db=get_spia_db,
    output:
        table="results/tables/pathways/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.pathways.tsv",
        plots="results/plots/pathways/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.spia-perturbation-plots.pdf",
    params:
        bioc_species_pkg=bioc_species_pkg,
        pathway_db=config["enrichment"]["spia"]["pathway_database"],
    conda:
        enrichment_env
    log:
        "logs/enrichment/spia/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.spia-pathways.log",
    threads: 32
    script:
        "../scripts/spia.R"