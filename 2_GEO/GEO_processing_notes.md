# Human acute-phase AIS transcriptomics layer

## Input datasets

- `GSE16561`: peripheral whole blood, 39 AIS and 24 healthy controls, GPL6883.
- `GSE58294`: blood, 23 vascular-risk-factor controls and 23 cardioembolic-stroke subjects at `<3 h`, GPL570. The 5 h and 24 h samples are not used in the primary contrast because they repeat the same patients.

The complete GEO series matrices and family SOFT metadata are preserved under `raw/`. GPL6883 platform annotation is also preserved.

## Statistical processing

Both series matrices are already processed log-scale expression data; no second log transformation or blind re-normalisation was applied. Probe-to-gene mapping was performed before gene-level limma analysis. Ambiguous GPL570 probes mapping to more than one symbol were excluded; duplicate probes for one gene were averaged with `limma::avereps`.

GSE16561 was analysed with `AIS - Control`, adjusting for centred age and sex because age differs between its groups. GSE58294 was analysed with `AIS <3 h - vascular-risk-factor control` without an invented age/sex covariate because those fields are not available in the downloaded matrix metadata. Differential expression used limma `lmFit`/contrast followed by robust empirical-Bayes moderation (`eBayes(robust=TRUE, trend=FALSE)`).

- Strict DEG: BH-FDR <0.05 and `|log2FC| >= 1`.
- Extended DEG: BH-FDR <0.05 and `|log2FC| >= 0.5`.
- Direction is always AIS minus Control.
- Replicated genes require significance, effect-size threshold and the same direction in both independent contrasts.

## Current results

- GSE16561: 532 extended DEGs and 20 strict DEGs.
- GSE58294 `<3 h`: 1,647 extended DEGs and 142 strict DEGs.
- Same-direction replicated sets: 144 extended genes and 4 strict genes.
- The GEO Series Matrix and platform annotation are the analysis authority. For GSE16561, the downloaded GEO matrix contains 39 AIS and 24 controls; this is retained even where older publication text reports a different control count/platform description.
- Same-direction replicated extended set: 146 genes.
- Same-direction replicated strict set: 4 genes: `ARG1`, `FOLR3`, `LY96`, `MMP9`.

These are human acute peripheral-blood response genes, not proof of brain-tissue causality or direct drug binding. They should be stored as an `Acute_Transcriptomics` evidence class and intersected with Bilobalide targets separately from GeneCards/OMIM/DisGeNET.

## Outputs

Processed differential-expression tables and merge-ready gene lists are under `processed/`; `AIS_GEO_QC.csv` records sample counts and DEG counts. The R script used for processing is `../scripts/process_ais_geo.R`.
