# Changelog

## [1.5.0](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/compare/v1.4.0...v1.5.0) (2025-04-03)


### Features

* make use of multiple samples when listed in config ([d7359eb](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/d7359ebc216dc37c29c8f0ced3ee752644efd825))
* showcase in example config/config.yaml, that multiple samples can be specified for both baseline and changed ([e0e3e60](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/e0e3e6091849853ae31c5785cf03ee20b9be583a))


### Bug Fixes

* adjust config to new sample spec under baseline and changed ([4eecc30](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/4eecc306a0d354d01bd1f45391a482f68ddfc6c2))
* gfold mem_mb usage seems to max out around 8000, so we give it some buffer with 10000 ([ad5bfa7](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/ad5bfa7f1052760e48224fab8c92448f19b7ef2c))
* latest datavzrd wrapper, ci updates, multiple samples for baseline and/or changed ([566d851](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/566d851a00cb23572b9320d3aae7b42ed8c12d6d))
* switch to latest datavzrd wrapper (all the features, template rendering included) ([82d0d1d](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/82d0d1de25fe749590da5402c605bd87dfc7ac56))
* try with list of sample names under baselin and changed ([a8899fa](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/a8899faf67efd13dd8125eb8d1dae973fe9b9545))
* turn on yte rendering of templates ([2983422](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/298342245a7890427e05019caac8381e8f06f521))
* update wildcards in yte datavzrd template ([7217355](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/7217355035c8ccf976d2ab573514bc2e8548f34d))

## [1.4.0](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/compare/v1.3.0...v1.4.0) (2025-03-25)


### Features

* add dotplot and barplot to gseapy output (for top_n genes, configurable via config.yaml) ([ea45fe5](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/ea45fe5cc71a048a98a3a5cc8b37f147935c2487))
* add pathbank and smpdb linkouts to spia_template.yaml ([41318ea](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/41318ea59505fcb90d7e1738bb60eba0f4dcc5be))
* handle all possible graphite pathwayDatabases in spia_template.yaml ([b15649a](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/b15649ad16d07fb18a62a3e11594c6d6e3d9776d))


### Bug Fixes

* fill in NA values in gene_symbol column with the ens_gene ID ([d58d6ea](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/d58d6ea7dc1aab594df736224ddd284dde245f71))
* keep ens_gene around as backup ([d05a820](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/d05a82010689abf6a4d06225dbceb5ae2a5ba07d))
* replace empty ext_gene/gene_symbol entries with ens_gene ID ([2b48b31](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/2b48b3151daf3404ae9cd54317306ec779c4db8c))


### Performance Improvements

* improve annotation of spia results in report ([aeb19c1](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/aeb19c1d313a2c45f32797d33ab39a317f36b897))
* remove excel file creations in datavzrd templates (should speed up datavzrd rules considerably) ([818264b](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/818264b46074c2ae035df6676257ac0247ef96e6))

## [1.3.0](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/compare/v1.2.0...v1.3.0) (2024-02-14)


### Features

* add gfold_0_01 cutoff specification via config.yaml ([28bda66](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/28bda6604ce53fd10395c24cbd059460aacaebad))
* add gseapy gene set enrichment (dryrun working, not tested otherwise) ([1600242](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/16002427322631445fceca7ab6c6eb24db8087ec))
* add gseapy gene set enrichment (dryrun working, not tested otherwise) ([9fadae7](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/9fadae7b0737355830a23fa99af705bd039d15f0))


### Bug Fixes

* add permissions for release-please ([96fc94f](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/96fc94f2adf53b562b3c14ba8ba912b5c7b493e6))
* add permissions for release-please ([012e2ce](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/012e2ce748cb64a0f72e44df0256da4abeb4ded8))
* gseapy.rst with correct wildcards and setup ([24680d4](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/24680d408694c6f3ad2f6050d222981dde65017c))
* gseapy.rst with correct wildcards and setup ([700be0c](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/700be0cf09b740677582a3fde0f91b60f5b0278a))
* make spia use pre-filtered gfold gene list ([89fe619](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/89fe619541120959a23dc5cf53f6430480adbc0c))
* transcript ID version numbers can be more than one digit long, adjust the regex ([b66715d](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/b66715dfd40e6fdbb95cec9a873e39f92495b604))
* try release-please with classic PAT ([b766250](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/b76625096f9b85925fb7e6004977e0a37e9723a8))
* try release-please with classic PAT ([8c4eec5](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/8c4eec5bc6d81e2fa79f178d755cdc4d3de1cc56))
* update datavzrd, to avoid failing on empty spia output ([56173f2](https://github.com/dlaehnemann/rna-seq-conservative-fold-change-without-replicates/commit/56173f2c5e82407405a965aa9d3a98d3c7cc8673))
