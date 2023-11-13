log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(tidyverse)

read_tsv(
    snakemake@input[["gfold"]],
    comment = "# "
) |>
  rename(
    gene_symbol = `#GeneSymbol`,
    transcript_id = GeneName,
    gfold_0_01 = `GFOLD(0.01)`,
    e_fdr = `E-FDR`,
    rpkm_baseline = `1stRPKM`,
    rpkm_changed = `2ndRPKM`
  ) |>
  filter(
    gfold_0_01 != 0
  ) |>
  arrange(
    desc(gfold_0_01)
  ) |>
  write_tsv(
    snakemake@output[["cleaned"]],
  )