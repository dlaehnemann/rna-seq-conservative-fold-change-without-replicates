log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(tidyverse)

read_tsv(
    str_c(snakemake@input[["kallisto_folder"]], "/", "abundance.tsv")
  select(
    target_id,
    target_id,
    tpm,
    eff_length
  ) |>
  write_tsv(
    snakemake@output[["gfold_tsv"]],
    col_names = FALSE
  )