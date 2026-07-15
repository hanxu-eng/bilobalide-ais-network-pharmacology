import csv
import json
from pathlib import Path

root = Path(__file__).resolve().parents[1]
ot = root / "2_OpenTargets"
raw = json.loads((ot / "OpenTargets_MONDO_1060198_direct_genetic_raw.json").read_text())
disease = raw["data"]["disease"]

def rows_for(source_key, source_label):
    out = []
    for row in disease[source_key]["rows"]:
        target = row["target"]
        if target.get("biotype") != "protein_coding":
            continue
        scores = {x["id"]: x["score"] for x in row.get("datasourceScores", [])}
        out.append({
            "Disease_ID": disease["id"],
            "Disease_Name": disease["name"],
            "Evidence_Class": "Human_Genetics",
            "Source_Database": source_label,
            "Gene_Symbol": target.get("approvedSymbol", "").upper(),
            "Ensembl_ID": target.get("id", ""),
            "Target_Name": target.get("approvedName", ""),
            "Overall_Association_Score": row.get("score", ""),
            "Source_Score": scores.get(source_label, ""),
            "Direct_Association": True,
            "Species": "Homo sapiens",
            "Retrieval_Date": "2026-07-15",
        })
    return out

gwas = rows_for("gwas", "gwas_credible_sets")
eva = rows_for("eva", "eva")

def write_csv(path, rows):
    fields = list(rows[0]) if rows else [
        "Disease_ID", "Disease_Name", "Evidence_Class", "Source_Database",
        "Gene_Symbol", "Ensembl_ID", "Target_Name", "Overall_Association_Score",
        "Source_Score", "Direct_Association", "Species", "Retrieval_Date"
    ]
    with path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        w.writerows(rows)

write_csv(ot / "OpenTargets_AIS_direct_GWAS_265_protein_coding.csv", gwas)
write_csv(ot / "OpenTargets_AIS_direct_EVA_8_protein_coding.csv", eva)

for name, rows in [("GWAS", gwas), ("EVA", eva)]:
    genes = sorted({r["Gene_Symbol"] for r in rows if r["Gene_Symbol"]})
    (ot / f"OpenTargets_AIS_direct_{name}_gene_symbols.txt").write_text(
        "\n".join(genes) + "\n", encoding="utf-8"
    )

union_genes = sorted({r["Gene_Symbol"] for r in gwas + eva if r["Gene_Symbol"]})
(ot / "OpenTargets_AIS_direct_HumanGenetics_union_gene_symbols.txt").write_text(
    "\n".join(union_genes) + "\n", encoding="utf-8"
)

all_rows = gwas + eva
write_csv(ot / "OpenTargets_AIS_genetic_evidence_master.csv", all_rows)

gwas_by_gene = {}
for r in gwas:
    gwas_by_gene.setdefault(r["Gene_Symbol"], []).append(r)
for r in eva:
    r["Evidence_Note"] = "EVA evidence; do not count as an independent class from GWAS."

qc = [
    ("Disease_ID", disease["id"]),
    ("Disease_Name", disease["name"]),
    ("GWAS_rows_protein_coding", len(gwas)),
    ("GWAS_unique_genes", len({r["Gene_Symbol"] for r in gwas})),
    ("EVA_rows_protein_coding", len(eva)),
    ("EVA_unique_genes", len({r["Gene_Symbol"] for r in eva})),
    ("Evidence_class_rule", "GWAS and EVA are grouped under one Human_Genetics class"),
    ("Indirect_associations", "excluded; direct association query only"),
]
with (ot / "OpenTargets_QC.csv").open("w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["Check", "Value"])
    w.writerows(qc)
