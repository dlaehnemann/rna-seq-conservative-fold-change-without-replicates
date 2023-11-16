**Pathway enrichment** performed with SPIA, for the contrast ``{snakemake.wildcards.sample_changed}-{snakemake.wildcards.unit_changed}_vs_{snakemake.wildcards.sample_baseline}-{snakemake.wildcards.unit_baseline}``

The table contains the following columns that have been renamed for descriptive titles (also see the `SPIA docs <https://rdrr.io/bioc/SPIA/man/spia.html>`_; for renamed columns, original spia column names are mentioned in parentheses): 
**Name** of the pathway;
**number of genes on the pathway** (``pSize``);
**number of DE genes per pathway** (``NDE``);
**total perturbation accumulation** (``tA``);
**Combined FDR** (``pGFdr``);
**Status** of the pathway, inhibited vs. activated.

The following columns (available from spia output), are hidden in this table in favour of the combined FDR as an overall assessment of the reliability of a pathway's perturbation.
You can access them per pathway by clicking on the leading ``+`` symbol of a row:
**p-value for at least NDE genes** (``pNDE``);
**p-value to observe a total accumulation** (``pPERT``);
**Combined p-value** (``pG``);
**Combined Bonferroni p-values** (``pGFWER``);
**pathway id** provided by the pathway database used.