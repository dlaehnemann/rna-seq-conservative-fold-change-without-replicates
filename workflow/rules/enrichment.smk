rule spia:
    input:
        filtered="results/gfold/{contrast}.cleaned_and_sorted.tsv",
        all_tested_annotated="results/gfold/{contrast}.all_tested_annotated.tsv",
        spia_db=get_spia_db,
    output:
        table="results/spia/tables/{contrast}.spia_pathways.tsv",
        plots="results/spia/plots/{contrast}.spia_perturbation_plots.pdf",
    params:
        bioc_species_pkg=bioc_species_pkg,
        pathway_db=config["enrichment"]["spia"]["pathway_database"],
    conda:
        enrichment_env
    log:
        "logs/enrichment/spia/{contrast}.spia_pathways.log",
    threads: 32
    script:
        "../scripts/spia.R"


rule spia_datavzrd:
    input:
        config=workflow.source_path("../resources/datavzrd/spia_template.yaml"),
        # files required for rendering the given configs
        spia_table="results/spia/tables/{contrast}.spia_pathways.tsv",
    output:
        report(
            directory(
                "results/datavzrd-reports/spia/{contrast}"
            ),
            htmlindex="index.html",
            caption="../report/spia_table.rst",
            category="Enrichment analysis",
            subcategory="spia",
            patterns=["index.html"],
            labels={
                "contrast": "{contrast}",
                "enrichment": "pathway",
            },
        ),
        config="results/datavzrd/spia/{contrast}.spia_pathways.yaml",
    log:
        "logs/datavzrd-reports/spia/{contrast}.log",
    params:
        pathway_db=config["enrichment"]["spia"]["pathway_database"],
    wrapper:
        "v5.9.0/utils/datavzrd"


rule gseapy:
    input:
        filtered="results/gfold/{contrast}.cleaned_and_sorted.tsv",
        unfiltered="results/gfold/{contrast}.all_tested_annotated.tsv",
    output:
        tsv="results/gseapy/{contrast}/{enrichr_library}.tsv",
        dotplot_top_n_genes="results/gseapy/{contrast}/{enrichr_library}.top_n_genes.dotplot.pdf",
        barplot_top_n_genes="results/gseapy/{contrast}/{enrichr_library}.top_n_genes.barplot.pdf",
    log:
        "logs/gseapy/{contrast}/{enrichr_library}.log",
    params:
        species=get_gseapy_species_name(config["resources"]["ref"]["species"]),
        number_of_top_genes=config["enrichment"]["gseapy"].get("top_n", 5),
    conda:
        "../envs/gseapy.yaml"
    script:
        "../scripts/gsea.py"


use rule spia_datavzrd as gseapy_datavzrd with:
    input:
        config=workflow.source_path("../resources/datavzrd/gseapy_template.yaml"),
        enrichment="results/gseapy/{contrast}/{enrichr_library}.tsv",
    output:
        report(
            directory(
                "results/datavzrd/gseapy/{contrast}/{enrichr_library}"
            ),
            htmlindex="index.html",
            category="Enrichment analysis",
            subcategory="gseapy: {enrichr_library}",
            caption="../report/gseapy.rst",
            labels={
                "contrast": "{contrast}",
                "enrichment": "gene set",
            },
        ),
        config="resources/datavzrd/gseapy/{contrast}/{enrichr_library}.yaml",
    log:
        "logs/datavzrd-reports/gseapy/{contrast}.{enrichr_library}.log",
