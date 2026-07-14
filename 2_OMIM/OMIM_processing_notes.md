# OMIM：急性缺血性卒中检索结果处理说明

## 1. 输入与完整性

- 输入文件：`OMIM-MIMATCH_result.xlsx`
- 检索词：`acute ischemic stroke`
- 下载日期：2026-07-14
- OMIM报告命中：2444条；实际导出：1000条。文件明确提示超过1000条后截断，因此不是完整检索结果。
- 原始文件SHA-256：`74f4ba6dd8bd32b4bf095f77d1fe54f5973297323be2c6adfc6864dd03cac647`

## 2. 关键纠错

该文件是MIM Match全文检索结果，不是疾病—基因映射表。`*`仅表示基因条目，不能证明该基因与AIS存在直接关系。旧处理把所有`*`且有Entrez的条目作为AIS基因，会把急性白血病、心肌缺血和正文偶然引用等大量噪声纳入。本次将524条基因搜索命中全部保留在审计层，但只从已核实的gene–phenotype链路提取疾病靶点。

## 3. 分层结果

- 原始记录：1000条；条目前缀为`*=525、#=421、%=32、无前缀=22`。
- Primary证据记录：11条；Extended病因学记录：62条；Excluded：927条。
- 超严格直接AIS基因：3个（ALOX5AP、F2、F5）。
- 推荐OMIM主集合：6个（在超严格3基因基础上加入成人单基因脑小血管病：ARHGEF15、HTRA1、NOTCH3）。
- 主集合+病因学扩展：28个唯一基因，仅用于敏感性分析。
- `%606799`虽然是直接卒中表型，但%表示分子基础未明确；PDE4D仅留在不确定性审计，不进入主集或扩展集。

## 4. 两项基于当前证据的调整

1. `NOS3 (*163729)`与`MYMY8 (#621469)`存在当前NCBI/OMIM关联，因此从“全文偶然命中”升级到Extended病因层。
2. `BSVD4 (#621313)`/`NIT1`为成人起病且可出现缺血和出血事件，因此列入混合性小血管病Extended层，而非完全排除。

## 5. 下游使用

- 主分析推荐：`OMIM_AIS_primary_gene_symbols_for_merge.txt`（6基因）。
- 最严格复核：`OMIM_AIS_ultrastrict_direct_gene_symbols.txt`（3基因）。
- 敏感性分析：`OMIM_AIS_primary_plus_extended_gene_symbols_for_sensitivity.txt`（28基因）。
- 与GeneCards、DisGeNET、TTD合并时按批准Gene Symbol/Entrez去重并保留来源字段；不要把524个gene search hits并入疾病靶点。

## 6. 方法学限制

本次结果仍被OMIM导出上限截断，且仅使用一个宽泛全文检索式。因此这些文件是对当前下载结果的严格清洗，不代表OMIM中所有AIS相关表型已经穷尽。建议后续分别用精确表型词和Gene Map/API补检，并把新证据追加到Curated_Links，而不要重新启用“所有*条目均纳入”的旧规则。

## 7. 主要核验来源

- OMIM条目结构与检索说明：https://pmc.ncbi.nlm.nih.gov/articles/PMC5662200/
- NCBI MedGen缺血性卒中#601367：https://www.ncbi.nlm.nih.gov/medgen/215292
- CADASIL GeneReviews：https://www.ncbi.nlm.nih.gov/books/NBK1500/
- HTRA1 disorder GeneReviews：https://www.ncbi.nlm.nih.gov/books/NBK32533/
- BSVD4/NIT1：https://www.ncbi.nlm.nih.gov/gene/4817
- BSVD6/CTSA：https://www.ncbi.nlm.nih.gov/medgen/1055914
