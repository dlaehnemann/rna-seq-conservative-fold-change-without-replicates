log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(tidyverse)

t2g <- read_rds(snakemake@input[["transcripts_annotation"]]) |>
  select(
    target_id,
    ext_gene
  )

read_tsv(
    str_c(snakemake@input[["kallisto_folder"]], "/", "abundance.tsv")
) |>
  left_join(target_id) |>
  mutate(
    RPKM = "NA"
  ) |>
  select(
    ext_gene,
    target_id,
    est_counts,
    eff_length,
    RPKM
  ) |>
  write_tsv(
    snakemake@output[["gfold_tsv"]],
    col_names = FALSE
  )