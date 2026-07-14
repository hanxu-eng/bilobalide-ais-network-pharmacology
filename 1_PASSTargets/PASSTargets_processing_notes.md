# PASS Targets（Bilobalide）处理说明

## 处理范围

本次仅将 PASS Targets 作为白果内酯的**预测靶点来源**处理。未使用急性缺血性卒中相关性、实验正反证、通路解释、PPI或富集结果对靶点进行删除或升级。所有平台返回的 Activity Score > 0 记录均保留为 prediction_only。

## 输入文件

- 原始文件：pt_predictions.tsv
- 化合物：Bilobalide（PubChem CID 73581）
- 检索日期：2026-07-14
- 平台：PASS Targets；当前网页说明使用 ChEMBL v36 数据
- 原始记录：105条（D=69，I=36）

## 清洗与标准化规则

1. Activity Score 按 Pa-Pi 原值保存，不能改名为 Probability，也不能推导Pa、Pi、IC50或药理方向。
2. D与I保留为不同模型证据：D为简单检测体系模型，I为复杂检测体系模型；D不等于实验确认的直接结合。
3. Propensity Score不用于筛选。原始值-1保留在Raw字段，同时Clean字段记为空值，状态记为No_positive_propensity_returned。
4. ChEMBL ID去除“_UNDEFINED MUTATION”等后缀后获得基础ID，变体信息另存Mutation_Context。
5. 94个规范化ChEMBL靶点全部映射至Homo sapiens（Tax ID 9606）。91个单蛋白、2个蛋白复合物、1个嵌合蛋白。
6. 蛋白复合物和嵌合蛋白按组分展开为基因时保留Component_Relationship、Complex_Derived和Chimeric_Derived标记，不能把组分解释为分别获得独立预测。
7. 分数阈值表仅用于描述性敏感性分析。除平台默认Activity Score>0外，0.01、0.05、0.10、0.20、0.30、0.40和0.50均不是PASS官方筛选阈值。

## 输出结果

- PASSTargets_Bilobalide_all_annotated.csv：105条原始预测证据及完整注释。
- PASSTargets_Bilobalide_target_level_all.csv：94个规范化ChEMBL靶点，D/I分列。
- PASSTargets_Bilobalide_human_all_gene_level.csv：98个人源预测基因，作为后续多预测数据库合并的PASS全集。
- PASSTargets_Bilobalide_D_type_gene_level.csv：69个具有D型预测证据的基因。
- PASSTargets_Bilobalide_I_type_gene_level.csv：40个具有I型预测证据的基因；包括复合物/嵌合靶点展开组分。
- PASSTargets_Bilobalide_activity_threshold_summary.csv：分数阈值描述表，不用于当前纳入/排除。
- PASSTargets_Bilobalide_gene_symbols_for_merge.txt：98个Gene Symbol，一行一个。
- PASSTargets_Bilobalide_processed_results.xlsx：上述结果与QC的汇总工作簿。

## 计数QC

- 105条原始记录；D=69，I=36；Propensity=-1共76条。
- 原始精确ChEMBL字符串95个；规范化后94个靶点实体。
- 11个靶点同时具有D/I记录；同一靶点同一类型内无重复。
- 基因展开后98个唯一Gene Symbol；D型69个，I型40个。

## 可用于论文的方法表述

于2026年7月14日将白果内酯结构提交至PASS Targets进行人源蛋白靶点预测。平台返回Activity Score（Pa-Pi）大于0的记录。D型与I型预测分别保留，并将同一ChEMBL靶点的两类分数横向整理，未对D/I分数求和或取平均。Propensity Score仅作为检测选择倾向信息保存，不参与靶点筛选；平台未返回正Propensity的记录记为缺失。随后依据ChEMBL靶点组件信息将结果标准化至Gene Symbol和UniProt accession；蛋白复合物及嵌合蛋白组分保留来源标记。所有平台返回的预测均纳入PASS预测靶点全集，最终获得94个规范化ChEMBL靶点实体及98个人源基因。
