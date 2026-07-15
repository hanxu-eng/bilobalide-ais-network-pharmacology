# AIS target layer processing notes

## Purpose

This folder freezes four human protein-coding acute ischemic stroke (AIS) target layers from GeneCards, OMIM and DisGeNET. DrugBank is intentionally not included at this stage.

## Layer definitions

- **Strict_28:** GeneCards Relevance Score ≥5 + OMIM ultra-strict direct genes + DisGeNET exact AIS raw GDA ≥0.30.
- **Primary_81:** GeneCards Relevance Score ≥3 + OMIM primary genes + DisGeNET exact AIS raw GDA ≥0.30. This is the recommended primary disease set.
- **MediumExtended_176:** GeneCards main + OMIM primary/extended + DisGeNET conservative EI ≥0.80 sensitivity set.
- **BroadSensitivity_430:** GeneCards Relevance Score ≥0.9 + OMIM primary/extended + DisGeNET human-literature sensitivity set. Use only for expanded exploration.

Each layer is a union of its component databases, followed by Gene Symbol deduplication. Database intersection is retained as a support-count attribute rather than used as an exclusion rule.

## Quality control

- Counts: strict=28, primary=81, medium=176, broad=430.
- Layers are nested: True.
- Duplicate Gene Symbols in master: 0.
- Format-invalid Gene Symbols: none.
- Primary genes supported by at least two databases: 12.

## Interpretation limits

GeneCards relevance is query-dependent, OMIM records reflect curated genetic/phenotypic relationships, and current DisGeNET AIS associations are largely literature-mined. Membership is disease association evidence, not proof of causality or druggability.

- The available OMIM MIM Match snapshot contains 1000 of 2444 returned records, so the OMIM layer is curated but not an exhaustive database export.
- The GeneCards thresholds and the DisGeNET conservative EI ≥0.80 sensitivity rule are project-defined analysis choices rather than universal official cutoffs.
- GeneCards relevance and DisGeNET association scores must not be interpreted as probabilities.

## Intended next step

Use `AIS_targets_primary_81_gene_symbols.txt` for the primary drug–disease intersection, `AIS_targets_strict_28_gene_symbols.txt` for strict sensitivity, and the 176/430-gene lists only for expanded sensitivity/PPI exploration.
