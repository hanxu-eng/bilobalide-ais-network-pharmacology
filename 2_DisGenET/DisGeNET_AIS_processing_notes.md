# DisGeNET：急性缺血性卒中（AIS）结果处理说明

## 1. 输入文件与疾病范围

- 主输入：`search_result_acute ischemic stroke.xlsx`
- 精确疾病实体：`Acute Ischemic Stroke`；UMLS CUI：`C5392833`
- 主输入记录：522条、522个唯一Gene Symbol、522个唯一Entrez ID，无重复、无导出截断证据。
- 对照输入：`search_result_ischemic stroke.xlsx`；疾病实体为更宽泛的`Ischemic stroke / C0948008`，共2143条。本次不把它并入AIS靶点，只用于标记同一基因是否在宽表型中出现。
- 处理日期：2026-07-14
- 主输入SHA-256：`b3946eeb8e70630ea76c413f6560466a48f3897fd64bff5da556a8a7575d3ee5`
- 对照输入SHA-256：`11a90538cd98e63a7d01aaf5b07694a241bfc0890924ef26199000d463688868`

## 2. 严格AIS主集合

筛选条件：Disease严格等于`Acute Ischemic Stroke`；Disease CUI严格等于`C5392833`；将原始`score`由文本转为数值；`raw score >= 0.30`；Gene Type为`protein-coding`；按Entrez ID去重。

结果共11个基因：ALB、BDNF、CRP、GFAP、IL6、MMP9、NPPB、PLA2G7、PLAT、TNF、VEGFA。该集合推荐用于与GeneCards、OMIM、TTD疾病基因集合合并。

## 3. 扩展与敏感性集合

- `0.20 <= raw score < 0.30`：153条，其中132个protein-coding、21个ncRNA；只用于扩展分析。
- `raw score >= 0.20 + protein-coding`：143个基因，保留为与既有SOP兼容的宽松敏感性集合。
- 在143个基因中进一步要求`N PMIDs >= 2`且Score Breakdown含`TEXTMINING_HUMAN`：140个。推荐作为扩展敏感性集合。
- 在140个基因中附加研究者定义的`EI >= 0.80`：123个。该EI门槛不是DisGeNET官方标准，仅作为保守敏感性分析。
- 80个ncRNA和2个pseudo单独保留，默认不输入STRING蛋白PPI。

## 4. 关键方法学纠错

1. SOP中的`GDA >= 0.30`本次作用于原始`score`列，而不是`Normalized score`。本文件Normalized score最高仅0.2258；如果误用`Normalized score >= 0.30`会得到0个基因。
2. 本文件每条Normalized score均等于raw score/1.55，因此二者不是两项独立证据，不能重复叠加筛选。
3. 522条均有Literature文本挖掘证据；423条为人类文本挖掘、64条为模型文本挖掘、35条同时有人类和模型文本挖掘。没有Curated、Clinical、Inferred或Biobank得分来源。
4. GDA score代表证据量和来源权重，不是概率、效应量、因果性或治疗靶点验证。论文应使用“DisGeNET AIS相关基因”，不能直接写成“致病基因”或“已验证治疗靶点”。
5. `C0948008 Ischemic stroke`是不同且更宽的疾病概念。它与精确AIS文件重叠382个基因，但不得把其余1761个基因转移进AIS集合。

## 5. 下游推荐

- 主分析：`DisGeNET_AIS_primary_gene_symbols_for_merge.txt`（11基因）。
- 推荐扩展敏感性分析：`DisGeNET_AIS_sensitivity_human_literature_gene_symbols.txt`（140基因）。
- 更保守敏感性分析：`DisGeNET_AIS_sensitivity_conservative_gene_symbols.txt`（123基因）。
- STRING PPI前保留protein-coding，非编码RNA只在专门的RNA机制分析中使用。
- 合并其他疾病数据库时按批准Gene Symbol与Entrez ID去重，并保留`Source=DisGeNET`、Disease CUI、raw score和证据层级。

## 6. 主要方法来源

- DisGeNET GDA score说明：https://support.disgenet.com/support/solutions/articles/202000100283-what-are-the-gda-score-vda-score-disgenet-score-
- DisGeNET scores总览：https://support.disgenet.com/support/solutions/articles/202000118694-understanding-disgenet-scores
- DisGeNET平台论文：https://academic.oup.com/nar/article/48/D1/D845/5611674
- NCBI MedGen Acute Ischemic Stroke C5392833：https://www.ncbi.nlm.nih.gov/medgen/1709065
