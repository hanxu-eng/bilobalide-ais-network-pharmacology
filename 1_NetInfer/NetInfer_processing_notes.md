# NetInfer（Bilobalide）处理说明

## 处理范围

本次仅将NetInfer结果作为白果内酯的**计算预测靶点来源**进行处理。没有使用急性缺血性卒中相关性、通路机制、实验正反证、PPI或富集结果删除预测记录。数字Rank 1–50的记录全部保留为`prediction_only`；平台标记为`Known`的GLRA2单列为已知网络参考，不计入NetInfer预测集。

## 输入文件与模型设置

- 原始文件：`NetInfer_Bilobalide_wSDTNBI_Global2020_MorganFCFP4_top50_raw.csv`
- 化合物：Bilobalide（PubChem CID 73581）
- 结果处理日期：2026-07-14
- Prediction type：Target proteins
- Method：wSDTNBI
- Network：Global DTI network（version 2020）
- Fingerprint：Morgan fingerprint，FCFP_4-like（radius=2，useFeatures=True）
- 参数：α=0.4，β=0.2，γ=-0.5，δ=20，ε=4，k=2
- 请求预测数量：Top 50
- 原始数据：51条，其中50条数字Rank预测，另有1条`Known`参考记录

## 清洗与标准化规则

1. `Target ID`按UniProt accession整理为`UniProt_Accession`；平台原字段仍可由原始文件追溯。
2. `Gene ID`原值均带末尾分号，原样保存在`Entrez_Gene_ID_Raw`，去掉空分隔项后保存为`Entrez_Gene_ID`。
3. 全部51条记录均为`Homo sapiens (Human)`，统一补充Tax ID 9606。
4. 数字Rank 1–50标记为`NetInfer_Prediction`并纳入预测集；Top 20仅作为优先查看的描述性排名层，不代表官方阈值。
5. `Rank=Known`的GLRA2标记为`Known_Network_Reference`：不改成第51名，不计入Top 50、分数分布或NetInfer新增预测证据。
6. `Score`按平台原值保存并用于模型内部排序。Score可大于1，不能解释为概率、置信率、结合亲和力、IC50，也不与其他数据库的评分直接相加或横向比较。
7. Protein family缺失的CBX1、SHBG和PAX8保留为`NA`，不因此删除记录。
8. CHRNA10与CHRNA9的Score同为1.64045，分别保留平台Rank 11和12，不重新排序。
9. Original SMILES和Prepared SMILES均通过PubChem PUG REST fastidentity解析至CID 73581，确认平台结构标准化未改变化合物身份。

## 结果与QC

- 50条预测记录，Rank完整覆盖1–50，无缺号、无重复。
- 预测Score范围：0.752609–2.67584；均值1.299946；中位数1.18163。
- 50个预测靶点对应50个唯一UniProt accession、50个唯一Gene Symbol和50个唯一Entrez Gene ID。
- 1条Known参考：GLRA2（UniProt P23416，Entrez 2742，平台Score 0.347287）。
- 全部记录均为人源；没有因疾病相关性或生物学推断删除记录。

## 输出文件

- `NetInfer_Bilobalide_all_annotated.csv`：51条完整审计记录，包含预测/Known分类、标准化ID和QC说明。
- `NetInfer_Bilobalide_predicted_top50.csv`：50条NetInfer预测记录，作为NetInfer预测全集。
- `NetInfer_Bilobalide_priority_top20.csv`：排名前20的描述性优先层，不是官方置信度阈值。
- `NetInfer_Bilobalide_predicted_gene_level.csv`：50个人源唯一预测基因，供后续多数据库合并。
- `NetInfer_Bilobalide_known_reference.csv`：单独保存GLRA2已知网络参考记录。
- `NetInfer_Bilobalide_gene_symbols_for_merge.txt`：仅包含50个预测Gene Symbol，一行一个；不包含GLRA2。
- `NetInfer_Bilobalide_rank_summary.csv`：Top10/20/30/50的描述性分数统计。
- `NetInfer_Bilobalide_processed_results.xlsx`：输入、分层结果、QC和方法记录的汇总工作簿。

## 后续使用原则

- 后续药物预测靶点全局合并时，使用50基因预测集；GLRA2应由已知/实验靶点证据层单独管理，避免把`Known`误计为NetInfer独立预测支持。
- NetInfer预测结果不提供激动/拮抗、促进/抑制或直接/间接作用方向。
- 排名较高只表示在该模型内部优先级较高；不能据此宣称靶点已被实验验证。

## 可用于论文的方法表述

将白果内酯结构提交至NetInfer，选择Target proteins，以Global DTI network（version 2020）为参考网络，采用wSDTNBI方法及Morgan/FCFP_4-like指纹进行靶点推断（α=0.4、β=0.2、γ=-0.5、δ=20、ε=4、k=2），保留平台返回的Top 50人源预测靶点。随后将靶点统一整理为UniProt accession、Gene Symbol及Entrez Gene ID并去重。平台额外标记为Known的GLRA2作为已知网络参考单列，不纳入NetInfer预测靶点计数。wSDTNBI Score仅用于模型内部排序，不作为概率或结合亲和力解释。

## 方法与结构来源

- NetInfer论文：https://doi.org/10.1021/acs.jcim.0c00291
- wSDTNBI论文：https://doi.org/10.1039/D1SC05613A
- PubChem Bilobalide：https://pubchem.ncbi.nlm.nih.gov/compound/73581
