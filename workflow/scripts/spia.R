log <- file(snakemake@log[[1]], open = "wt")
sink(log)
sink(log, type="message")

library("SPIA")
library("graphite")
library(snakemake@params[["bioc_species_pkg"]], character.only = TRUE)
library("tidyverse")

pw_db <- snakemake@params[["pathway_db"]]
db <- readRDS(snakemake@input[["spia_db"]])

options(Ncpus = snakemake@threads)

universe <- read_tsv(snakemake@input[["all_tested_annotated"]]) |>
    drop_na(gene_id) |>
    mutate(
        gene_id = str_c("ENSEMBL:", gene_id)
    ) |>
    dplyr::select(gene_id) |>
    distinct() |>
    pull(gene_id)

changed_genes <- read_tsv(snakemake@input[["filtered"]]) |>
    mutate(
        abs_gfold = abs(gfold_0_01),
        gene_id = str_c("ENSEMBL:", gene_id)
    ) |>
    group_by(gene_id) |>
    slice_max(
        abs_gfold,
        with_ties = FALSE
    )

columns <- c(
  "Name",
  "number of genes on the pathway",
  "number of DE genes per pathway",
  "p-value for at least NDE genes",
  "total perturbation accumulation",
  "p-value to observe a total accumulation",
  "Combined p-value",
  "Combined FDR",
  "Combined Bonferroni p-values",
  "Status",
  "pathway id"
)

if (nrow(changed_genes) == 0) {
    # the best hack for an empty tibble from a column specification I could find
    res <- read_csv("\n", col_names = columns)
    write_tsv(res, snakemake@output[["table"]])
} else {
    # get conservative fold change estimate from gfold
    gfold <- changed_genes |>
        dplyr::select(
            gene_id,
            gfold_0_01
        ) |>
        deframe()

    t <- tempdir(check = TRUE)
    olddir <- getwd()
    setwd(t)
    prepareSPIA(db, pw_db)
    res <- runSPIA(
        de = gfold,
        all = universe,
        pw_db,
        plots = TRUE,
        verbose = TRUE
    )
    setwd(olddir)

    file.copy(
        file.path(t, "SPIAPerturbationPlots.pdf"),
        snakemake@output[["plots"]]
    )
    pathway_names <- db[res$Name]
    if (length(pathway_names) > 0) {
        pathway_ids_tibble <- pathway_names@entries |>
          map(slot, "id") |>
          unlist() |>
          as_tibble(
            rownames="pathway_name"
          ) |>
          rename(
            `pathway id` = value
          )
        final_res <- as_tibble(res) |>
          left_join(
            pathway_ids_tibble,
            join_by(Name == pathway_name)
          ) |>
          rename(
            "number of genes on the pathway" = "pSize",
            "number of DE genes per pathway" = "NDE",
            "p-value for at least NDE genes" = "pNDE",
            "total perturbation accumulation" = "tA",
            "p-value to observe a total accumulation" = "pPERT",
            "Combined p-value" = "pG",
            "Combined FDR" = "pGFdr",
            "Combined Bonferroni p-values" = "pGFWER"
          ) |>
          dplyr::select(
            all_of(
                columns
            )
          ) |>
          arrange(
            desc(`total perturbation accumulation`)
          )
        write_tsv(final_res, snakemake@output[["table"]])
    } else {
        # the best hack for an empty tibble from a column specification I could find
        emtpy_data_frame <- read_csv("\n", col_names = columns)
        write_tsv(emtpy_data_frame, snakemake@output[["table"]])
    }
}