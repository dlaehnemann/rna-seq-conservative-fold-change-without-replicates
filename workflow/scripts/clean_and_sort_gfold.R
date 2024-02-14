log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(tidyverse)

gfold_0_01_cutoff <- as.numeric(snakemake@params[["gfold_0_01_cutoff"]])

t2g <- read_rds(snakemake@input[["transcripts_annotation"]]) |>
  select(
    target_id,
    ens_gene
  )

all_tested_annotated <- read_tsv(
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
  mutate(
    transcript_id_no_version = str_replace(transcript_id, "\\.\\d+", "")
  ) |>
  left_join(
    t2g,
    by = join_by(transcript_id_no_version == target_id)
  ) |>
  select(
    !transcript_id_no_version
  ) |>
  rename(
    gene_id = ens_gene
  )

write_tsv(
  all_tested_annotated,
  snakemake@output[["all_tested_annotated"]]
)

all_tested_annotated |>
  filter(
    abs(gfold_0_01) > gfold_0_01_cutoff
  ) |>
  arrange(
    desc(gfold_0_01)
  ) |>
  write_tsv(
    snakemake@output[["cleaned"]],
  )