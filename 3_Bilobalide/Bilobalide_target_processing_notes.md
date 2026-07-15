# Bilobalide target layer processing notes

## Purpose

This folder freezes four human gene-level Bilobalide target layers for the drug–AIS intersection stage. Source files were read without modification, Gene Symbols were trimmed, converted to uppercase and globally deduplicated.

## Layer definitions

- **Strict_25:** four predictor-specific strict sets (SwissTargetPrediction, SuperPred, PharmMapper strict and PPB3 reliable) merged by union.
- **CrossPriority_22:** genes present in at least two of the seven selected source sets. COMET is counted in the raw source count, but its very low probabilities mean it is corroborative rather than independent high-confidence evidence. The master table therefore also reports support excluding COMET; this count is 21.
- **Recommended_42:** Strict_25 ∪ CrossPriority_22. This is the recommended primary Bilobalide set for intersection analysis.
- **Extended_171:** all selected prediction-source sets merged and deduplicated. Use only for exploratory/sensitivity analysis.

## Important interpretation

All records are computational predictions. Source repetition helps prioritize hypotheses but does not constitute experimental validation, and predictors may share training data. PharmMapper_selected uses the exploratory rule Norm-Fit ≥0.7 and z-score ≥0; PASSTargets scores are Pa−Pi rather than probabilities; COMET probabilities are very low.

## Quality control

- Counts: strict=25, cross-priority=22, recommended=42, extended=171.
- Duplicate Gene Symbols in master: 0.
- Format-invalid Gene Symbols: none.
- Source-count distribution: {1: 149, 2: 21, 4: 1}.

## Intended next step

Use `Bilobalide_targets_recommended_42_gene_symbols.txt` for the primary drug–disease intersection and `Bilobalide_targets_extended_171_gene_symbols.txt` only for expanded sensitivity/PPI exploration.
