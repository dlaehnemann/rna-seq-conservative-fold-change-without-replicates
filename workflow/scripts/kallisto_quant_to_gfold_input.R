log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(tidyverse)

read_tsv(
    str_c(snakemake@input[["kallisto_folder"]], "/", "abundance.tsv")
) |>
  mutate(
    repeat_id = target_id,
    RPKM = "NA"
  ) |>
  select(
    target_id,
    est_counts,
    eff_length,
    RPKM
  ) |>
  write_tsv(
    snakemake@output[["gfold_tsv"]],
    col_names = FALSE
  )