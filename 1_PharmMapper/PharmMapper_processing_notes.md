# 白果内酯 PharmMapper 结果处理说明

## 输入与原则

- 2D提交结果：299条
- 3D提交结果：299条
- 合计原始记录：598条
- 处理日期：2026-07-11
- 物种限定：Homo sapiens / TaxID 9606，经UniProt核验

PharmMapper执行的是反向三维药效团映射。这里的“2D”和“3D”代表两次不同结构输入提交，不应表述为两个完全独立的预测算法。

## 预设分层

| 层级 | 条件 | 合并、限定人源并按基因去重后数量 |
|---|---|---:|
| 严格集 | Norm Fit >=0.9且zscore >=1 | 3 |
| 放宽集 | Norm Fit >=0.7且zscore >=1 | 12 |
| 探索集 | Norm Fit >=0.7且zscore >=0 | 23 |

本次选定层级：**exploratory**，共**23**个靶点。

选择理由：所有预设层级经人源筛选和基因去重后均少于100个；保留最宽的预设探索集，不再事后继续降低阈值。

不得为了把结果凑到100-180个而继续事后下调Norm Fit或zscore。靶点数量是质量检查指标，不是必须实现的统计终点。

## 2D/3D一致性

| 层级 | 2D靶点 | 3D靶点 | 交集 | Jaccard |
|---|---:|---:|---:|---:|
| 严格 | 1 | 2 | 0 | 0.000 |
| 放宽 | 8 | 6 | 2 | 0.167 |
| 探索 | 16 | 12 | 5 | 0.217 |

## 输出文件

- PharmMapper_Bilobalide_all_annotated.csv：全部598条记录及人源映射审计。
- PharmMapper_Bilobalide_strict_human_deduplicated.csv：严格集。
- PharmMapper_Bilobalide_relaxed_human_deduplicated.csv：放宽集。
- PharmMapper_Bilobalide_exploratory_human_deduplicated.csv：探索集。
- PharmMapper_Bilobalide_selected_main_set.csv：按预设决策规则选出的主分析集。
- PharmMapper_Bilobalide_processed_results.xlsx：所有结果及QC汇总。

## 推荐方法学表述

> 分别以PubChem提供的白果内酯二维及三维SDF结构提交至PharmMapper进行反向药效团映射。结果依据UniProt进行靶点标准化和物种核验，仅保留Homo sapiens（TaxID 9606）蛋白。主分析首先采用Norm Fit >=0.9且zscore >=1的严格标准；当严格集不足时，依次采用Norm Fit >=0.7且zscore >=1以及Norm Fit >=0.7且zscore >=0的预设放宽标准。两次提交结果合并后按标准Gene Symbol去重，并保留每个靶点的最佳Norm Fit、对应zscore、来源和药效团模型。由于二维和三维结构均进入同一反向药效团框架，两次提交的一致性仅作为稳健性描述，不视为独立验证。
