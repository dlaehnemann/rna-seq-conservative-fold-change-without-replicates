**Conservative fold change estimates** as determined by ``gfold`` for sample ``{{ snakemake.wildcards.sample_changed }}-{{ snakemake.wildcards.unit_changed}}`` against baseline sample ``{{ snakemake.wildcards.sample_baseline }}-{{ snakemake.wildcards.unit_baseline }}``.
Columns are as follows:
* **transcript_id**: Ensembl transcript ID.
* **gene_symbol**: HGNC gene symbols with linkout to genecards.org.
* **gfold_0_01**: GFOLD value at -sc 0.01 for every gene. The GFOLD value could be considered as a reliable log2 fold change. It is positive/negative if the gene is up/down regulated. The main usefulness of GFOLD is to provide a biological meanlingful ranking of the genes. The GFOLD value is zero if the gene doesn't show differential expression. If the log2 fold change is treated as a random variable, a positive GFOLD value x means that the probability of the log2 fold change (2nd/1st) being larger than x is (1 - the parameter specified by -sc); A negative GFOLD value x means that the probability of the log2 fold change (2st/1nd) being smaller than x is (1 - the parameter specified by -sc). If this file is sorted by this column in descending order then genes ranked at the top are differentially up-regulated and genes ranked at the bottom are differentially down-regulated. Note that a gene with GFOLD value 0 should never be considered differentially expressed. However, it doesn't mean that all genes with non-negative GFOLD value are differentially expressed. For taking top differentially expressed genes, the user is responsible for selecting the cutoff.
* **e_fdr**: Empirical FDR based on replicates. It is always 1 when no replicates are available.
* **log2fdc**: log2 fold change. If no replicate is available, and -acc is T, log2 fold change is based on read counts and normalization constants. Otherwise, log2 fold change is based on the sampled expression level from the posterior distribution.
* **rpkm_baseline**: The RPKM for the baseline condition as specified in the ``config/config.yaml`` contrasts. It is available only if gene length is available. If multiple replicates are available, the RPKM is calculated simply by summing over replicates. Because RPKM is acturally using sequencing depth as the normalization constant, log2 fold change based on RPKM could be different from the log2fdc field.
* **rpkm_changed**: The RPKM for the changed condition. Also see ``rpkm_baseline``.

To learn more about ``gfold``, please have a look at:
* `the gfold overview and help website for basic usage <https://zhanglab.tongji.edu.cn/softwares/GFOLD/index.html>`_
* `the gfold publication for details on the methodology <https://doi.org/10.1093/bioinformatics/bts515>`_

