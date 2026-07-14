# GeneCards：急性缺血性卒中靶点检索与筛选说明

## 1. 数据来源与可追溯性

- 数据库：GeneCards 6.1 Build 2026-07-07
- 疾病：Acute ischemic stroke
- MeSH：D000083242
- 主检索式："acute ischemic stroke"
- 检索方式：精确短语（Exact phrase），范围为GeneCards全部索引字段
- 在线复核日期：2026-07-11
- 在线结果数：822；与项目中的完整CSV快照822条一致，Top结果一致
- 原始CSV自身未记录检索日期；文件mtime为2026-07-10 23:07:49 +08:00，仅作文件元数据，不能冒充检索日期
- 原始文件SHA-256：3b25937eecdc4ef41bc278c0a27a9be610d2f1ac35e0d84273be0c558d692956

原始快照在输出目录中按字节原样保留为 `GeneCards_AIS_raw_snapshot_original.csv`。

## 2. 为什么不能把0.75或0.9当成概率阈值

GeneCards Relevance Score表示基因与当前检索式的匹配强度，分数依赖检索词、引号、布尔关系和检索字段。它不是0–1概率、置信度、效应量或因果证据，GeneCards官方也未规定统一生物学阈值。

本次原始分数范围为0.30110064–21.936646，中位数1.6111301。若按原始分数筛选：

- ≥0.75：525条，其中蛋白编码397条；
- ≥0.9：511条，其中蛋白编码383条；
- ≥3：97条，其中蛋白编码76条；
- ≥5：31条，其中蛋白编码22条。

因此0.75/0.9在本数据中属于宽松绝对分数，不能写成“75%/90%概率”。经验分位数也另列在Thresholds表，不能和原始分数混为一谈。

## 3. 推荐分层

1. 主分析集：Raw Relevance Score ≥3，且Gene Type = Protein Coding，共76个基因。
2. 严格敏感性集：Raw Relevance Score ≥5，且Protein Coding，共22个基因。
3. 宽松敏感性集：Raw Relevance Score ≥0.9，且Protein Coding，共383个基因。
4. 用户参考集：Raw Relevance Score ≥0.75，且Protein Coding，共397个基因。
5. 完整注释集：822条全部保留，不直接作为STRING/PPI输入。

≥3与≥5均为本项目预设经验阈值，不是GeneCards官方标准。不要为了把多数据库疾病靶点总数强行控制在800–1500而事后反复调整本阈值。

## 4. 人源与基因类型

GeneCards是人类基因数据库，本输出增加Species = Homo sapiens、TaxID = 9606作为审计字段。原始822条包括630条Protein Coding、187条RNA Gene、2条Genetic Locus和3条Functional Element。

后续药物靶点与STRING PPI均以蛋白为主，所以主PPI文件只保留Protein Coding；其他类型没有静默删除，仍保留在All_Annotated和Main_ge3_All中。

## 5. 推荐下游用法

- 主药物–疾病交集：`GeneCards_AIS_main_score_ge3_protein_coding.csv`或`GeneCards_AIS_main_gene_symbols_for_Venny.txt`。
- 稳健性检查：分别用严格集和宽松集重跑交集、PPI与富集，报告核心结论是否稳定。
- 与DisGeNET、OMIM、TTD合并后，再进行HGNC/UniProt统一ID和全局去重。本阶段不伪造UniProt映射，字段明确标记Pending。
- 不使用Knowledge Score筛疾病靶点；该分数仅表示该基因被研究/注释的丰富程度。

## 6. 可直接写入论文的方法段

“于2026-07-11访问GeneCards数据库（version 6.1），以精确短语"acute ischemic stroke"检索急性缺血性卒中相关基因。保存完整原始结果并记录检索式、版本及数据完整性信息。GeneCards Relevance Score按原始值处理，不解释为概率。预先设定Raw Relevance Score ≥3为主筛选阈值，≥5为严格敏感性阈值；因后续需与药物蛋白靶点取交集并构建STRING网络，PPI就绪集仅保留Protein Coding记录。所有非蛋白编码记录在审计表中保留。随后与DisGeNET、OMIM及TTD结果合并，统一为标准Gene Symbol/UniProt ID并全局去重。”

## 7. 官方来源

- GeneCards检索指南：https://docs.genecards.org/genecards/guide/search/term-search
- GeneCards搜索结果：https://www.genecards.org/search/results?q=%22acute+ischemic+stroke%22
- GeneCards版本主页：https://www.genecards.org/
- NLM MeSH Ischemic Stroke：https://meshb.nlm.nih.gov/record/ui?name=ischemic+stroke
