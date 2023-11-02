This workflow expects `kallisto quant` output files (`abundance.tsv`) as input.
These can for example be obtained via [the `rna-seq-kallisto-sleuth` workflow](https://snakemake.github.io/snakemake-workflow-catalog/?repo=snakemake-workflows/rna-seq-kallisto-sleuth).
You can wire this workflow to existing count file directories and set up which samples to contrast with which in the `config/config.yaml` file.
This file contains explanatory comments for all of its entries.
