# Snakemake workflow: `rna-seq-conservative-fold-change-without-replicates`

[![Snakemake](https://img.shields.io/badge/snakemake-≥6.3.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/workflows/Tests/badge.svg?branch=main)](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/actions?query=branch%3Amain+workflow%3ATests)


A Snakemake workflow for to determine conservative fold changes between transcriptomic samples when no biological replicates are available.
It uses [GFOLD](https://zhanglab.tongji.edu.cn/softwares/GFOLD/index.html) for conservatively estimating the fold changes.


## Usage

The usage of this workflow is described in the [Snakemake Workflow Catalog](https://snakemake.github.io/snakemake-workflow-catalog/?usage=dlaehnemann%2Frna-seq-conservative-fold-change-without-replicates).

If you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) repository and its DOI (see above).
And please also cite the [GFOLD paper](https://doi.org/10.1093/bioinformatics/bts515), as this is the main tool used here:

Jianxing Feng, Clifford A. Meyer, Qian Wang, Jun S. Liu, X. Shirley Liu, Yong Zhang, GFOLD: a generalized fold change for ranking differentially expressed genes from RNA-seq data, Bioinformatics, Volume 28, Issue 21, November 2012, Pages 2782–2788, https://doi.org/10.1093/bioinformatics/bts515