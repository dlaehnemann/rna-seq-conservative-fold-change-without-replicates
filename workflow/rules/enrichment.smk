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
        table="results/spia/tables/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.spia_pathways.tsv",
        plots="results/spia/plots/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.spia_perturbation_plots.pdf",
    params:
        bioc_species_pkg=bioc_species_pkg,
        pathway_db=config["enrichment"]["spia"]["pathway_database"],
    conda:
        enrichment_env
    log:
        "logs/enrichment/spia/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.spia_pathways.log",
    threads: 32
    script:
        "../scripts/spia.R"


rule render_datavzrd_config_spia:
    input:
        template=workflow.source_path("../resources/datavzrd/spia_template.yaml"),
        spia_table="results/spia/tables/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.spia_pathways.tsv",
    output:
        "results/datavzrd/spia/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.spia_pathways.yaml",
    params:
        pathway_db=config["enrichment"]["spia"]["pathway_database"],
    log:
        "logs/datavzrd/spia/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.spia_pathways.yte_rendering.log",
    template_engine:
        "yte"


rule spia_datavzrd:
    input:
        config="results/datavzrd/spia/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.spia_pathways.yaml",
        # files required for rendering the given configs
        spia_table="results/spia/tables/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.spia_pathways.tsv",
    output:
        report(
            directory("results/datavzrd-reports/spia/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}"),
            htmlindex="index.html",
            caption="../report/spia_table.rst",
            category="Pathway enrichment",
            patterns=["index.html"],
            labels={"contrast": "{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}"},
        ),
    log:
        "logs/datavzrd-reports/spia/{sample_changed}-{unit_changed}_vs_{sample_baseline}-{unit_baseline}.log",
    wrapper:
        "v2.12.0/utils/datavzrd"