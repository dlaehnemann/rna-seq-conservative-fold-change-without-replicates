import sys
sys.stderr = open(snakemake.log[0], "w")

import pandas as pd
import gseapy as gp

background = pd.read_csv(snakemake.input.unfiltered, sep="\t").loc[:, "gene_symbol"].drop_duplicates()

gfold_change = pd.read_csv(snakemake.input.filtered, sep="\t").loc[:, "gene_symbol"].drop_duplicates()

if snakemake.wildcards.enrichr_library == "MSigDB_Hallmark_2020":
    def linkout_func(term):
        return f"https://www.gsea-msigdb.org/gsea/msigdb/cards/HALLMARK_{term.upper().replace(' ', '_')}"
elif snakemake.wildcards.enrichr_library in ("GO_Biological_Process_2020", "GO_Molecular_Function_2021", "GO_Cellular_Component_2021"):
    def linkout_func(term):
        goid = term.split(" ")[-1].strip("()")
        return f"https://www.ebi.ac.uk/QuickGO/term/{goid}"
else:
    def linkout_func(term):
        return f"https://www.google.com/search?q={term}"


if len(gfold_change) <= 1:
    # enrichment does only work with at least 2 genes
    pd.DataFrame(columns=["term", "linkout", "p-value", "FDR", "odds ratio", "genes"]).to_csv(snakemake.output[0], sep='\t', index=False)
else:
    gene_set = gp.parser.download_library(snakemake.wildcards.enrichr_library, snakemake.params.species)

    enrichment = gp.enrich(
        gene_list=gfold_change,
        gene_sets=[gene_set],
        background=background,
    )

    results = enrichment.results.sort_values("P-value")
    results.drop(columns="Gene_set", inplace=True)
    results.columns = results.columns.str.lower()
    results.rename(columns={"adjusted p-value": "FDR"}, inplace=True)

    # simplify floats
    for col in ["p-value", "FDR", "odds ratio"]:
        results[col] = results[col].map("{:.3g}".format)

    results.insert(1, "linkout", results["term"].map(linkout_func))

    results.to_csv(snakemake.output[0], sep='\t', index=False)
