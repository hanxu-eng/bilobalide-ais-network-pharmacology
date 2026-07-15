# Open Targets AIS human-genetics layer

## Input and query

- Disease: `ischemic stroke`
- Open Targets disease entity: `MONDO_1060198`
- Query mode: direct associations only (`enableIndirect=false`)
- Data sources exported separately: `gwas_credible_sets` and `eva`
- Species: Homo sapiens; only protein-coding targets retained
- Retrieval date: 2026-07-15

The raw GraphQL response is preserved in `OpenTargets_MONDO_1060198_direct_genetic_raw.json`. GWAS and EVA are grouped under one `Human_Genetics` evidence class and must not be counted as independent disease classes. Open Targets may contain evidence originating from the same studies represented in GWAS Catalog; therefore the two resources should not be added as two independent supports.

## Outputs

- `OpenTargets_AIS_direct_GWAS_265_protein_coding.csv`: 265 direct GWAS-associated protein-coding genes.
- `OpenTargets_AIS_direct_EVA_8_protein_coding.csv`: 8 direct EVA-associated protein-coding genes.
- `OpenTargets_AIS_genetic_evidence_master.csv`: combined audit table with source-level scores.
- `OpenTargets_AIS_direct_GWAS_gene_symbols.txt` and `OpenTargets_AIS_direct_EVA_gene_symbols.txt`: merge-ready symbols.
- `OpenTargets_QC.csv`: counts and query QC.

The association score is not a probability. If a project-specific L2G threshold is applied later, preserve the raw score and threshold in a new column; do not overwrite this layer.

## Intended use

Use this as an independent human-genetics disease module. Do not merge clinical-precedence or all-literature Open Targets associations into the AIS disease core. Those are therapeutic or literature-context layers and should remain separate.
