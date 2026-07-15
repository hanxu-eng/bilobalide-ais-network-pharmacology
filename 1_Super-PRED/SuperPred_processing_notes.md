# 白果内酯 Super-PRED 结果处理说明

## 数据来源

- 化合物：Bilobalide（PubChem CID 73581）
- 原始文件：`Targets-Super-PRED.csv`
- 原始记录：131 条
- 数据检索日期：2026-07-10（依据原始文件时间）
- 处理日期：2026-07-11
- UniProt 核验接口：<https://rest.uniprot.org/>

## 处理规则

1. 原始 `Probability` 和 `Model accuracy` 中的百分号被转换为可计算数值，同时保留原始字段。
2. 以原始 `UniProt ID` 查询 UniProt，补充标准 Gene Symbol、标准 accession、entry name、reviewed 状态和 TaxID。
3. 只将 `TaxID=9606` 的人源记录纳入严格集。
4. 主分析严格标准为：`Probability >80%` 且 `Model accuracy >85%`。
5. `Model accuracy` 表示对应靶点分类模型的交叉验证性能，不是当前白果内酯—靶点关系的第二个预测概率。
6. 原始表全部保留在 `all_annotated`；UniProt 去重表按 Probability 降序、再按 Model accuracy 降序保留每个 accession 的最佳记录。

## 质量控制结果

| 项目 | 数量/结果 |
|---|---:|
| 原始记录 | 131 |
| 唯一 UniProt accession | 130 |
| UniProt 成功映射 | 131/131 |
| 人源 TaxID=9606 | 131/131 |
| Probability >80% | 9 |
| Model accuracy >85% | 109 |
| 严格双阈值纳入 | 9 |

唯一重复 accession 为 `Q00535/CDK5`。原始文件中的两条模型记录均保留；在唯一 UniProt 表中保留 Probability 较高的记录。

## 严格主分析靶点

`APEX1, CNR2, TRIM24, TOP2A, CACNA1B, HIF1A, CSNK2B, NFKB1, CTSD`

这些均为计算预测候选靶点，不能直接称为白果内酯的实验验证靶点。后续应与其他药物靶点数据库整合、统一 ID、去重后，再与 AIS 疾病靶点取交集。

## 输出文件用途

- `SuperPred_Bilobalide_all_annotated.csv`：131 条原始记录的完整清洗和注释结果，用于审计。
- `SuperPred_Bilobalide_unique_uniprot_best_record.csv`：按 UniProt 去重后的 130 个候选靶点，用于探索性整合。
- `SuperPred_Bilobalide_strict_probability_gt80_model_accuracy_gt85.csv`：9 个严格主分析靶点，建议进入主药物靶点集合。
- `SuperPred_Bilobalide_processed_results.xlsx`：包含严格集、唯一 UniProt 集、完整注释表和 QC/方法说明。

## 方法学表述建议

> 将白果内酯结构提交至 SuperPred 3.0 进行潜在靶点预测。保留平台原始预测结果，并依据研究预设标准筛选 Probability >80% 且 Model accuracy >85% 的候选靶点。随后使用 UniProt 对靶点 accession 进行核验，限定物种为 Homo sapiens（TaxID 9606），补充标准 Gene Symbol 并按 UniProt accession 去重。需要指出，Model accuracy 表示靶点预测模型的交叉验证性能，而非单条化合物—靶点关系的独立概率。
