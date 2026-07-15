# 白果内酯–急性缺血性卒中网络药理学数据仓库

## 研究背景

本仓库用于整理白果内酯（Bilobalide）与急性缺血性卒中（acute ischemic stroke，AIS）相关性的网络药理学数据处理流程。研究从白果内酯化学结构出发，通过多个平台预测人源作用靶点，检索并整理AIS相关基因，随后完成标准Gene Symbol统一、全局去重、证据分层和药物–疾病靶点交集计算，为后续蛋白互作网络、网络拓扑和功能富集分析准备可追溯的数据输入。

仓库同时保留原始导出、清洗结果、证据主表、来源清单和质量控制文件。药物靶点主要属于计算预测结果，疾病靶点属于数据库关联结果；这些数据用于生成候选机制线索，不等同于直接结合、因果关系、可成药性或临床作用证据。

## 总体流程

```text
白果内酯2D/3D结构
        ↓
多平台药物靶点预测（阶段1）
        ↓
AIS疾病相关基因检索（阶段2）
        ↓
人源限定、ID标准化、全局去重与证据分层（阶段3）
        ↓
药物–疾病分层交集（阶段4，已完成）
        ↓
Venny / STRING / Cytoscape / cytoHubba（尚未执行）
        ↓
GO / KEGG等功能富集（尚未执行）
```

## 阶段状态

| 阶段 | 内容 | 当前状态 |
|---|---|---|
| 阶段0 | 化合物结构与参考数据整理 | 已完成 |
| 阶段1 | 白果内酯人源作用靶点预测 | 已整理；SEA暂无结果 |
| 阶段2 | AIS疾病相关基因检索与筛选 | 已完成 |
| 阶段3 | 药物和疾病靶点标准化、去重及分层 | 已完成 |
| 阶段4 | 输入冻结与四层交集计算 | 已完成 |
| 阶段4后续 | Venny、STRING、Cytoscape、cytoHubba | 尚未执行 |
| 后续分析 | GO、KEGG等功能富集 | 尚未执行，当前无结果目录 |

## 目录说明

### 阶段0：结构输入与参考数据

#### `0_结构图 Pubchem/`

保存从PubChem获得的白果内酯结构文件：

- `Structure2D_Bilobalide.sdf`：二维结构；
- `Conformer3D_Bilobalide.sdf`：三维构象。

这些文件是SwissTargetPrediction、PharmMapper及其他结构基础预测平台的化合物输入。

#### `0_Teacher/`

保存早期获取的结构预测、药物靶点和GeneCards结果快照，用于原始数据对照与格式核查。该目录不是当前标准化分析的默认输出；实际纳入文件和筛选规则应以阶段1至阶段3的处理说明、来源清单和证据主表为准。

### 阶段1：白果内酯作用靶点预测

#### `1_SwissTargetPrediction/`

保存SwissTargetPrediction原始返回及分层结果，包括Probability≥0.5的严格集、≥0.3的扩展集和≥0.1的探索集，并补充人源、Gene Symbol和UniProt字段。

#### `1_Super-PRED/`

保存SuperPred原始返回、完整注释表、UniProt去重结果和严格筛选结果。严格集采用Probability>80%且Model accuracy>85%；Model accuracy表示模型性能，不是当前白果内酯–靶点关系的第二个概率。

#### `1_PharmMapper/`

保存基于白果内酯二维和三维结构的反向药效团映射结果，包括人源严格、放宽和探索层，以及合并去重后的主选择集。主要筛选字段为Norm-Fit和z-score。

#### `1_PPB3/`

保存PPB3预测原始结果、完整审计表、全部人源基因级结果，以及Confidence Score>0.2的推荐可靠集合。

#### `1_PASSTargets/`

保存PASS Targets原始返回、D型和I型结果、靶点级及人源基因级标准化结果。Activity Score按平台返回的Pa−Pi解释，不作为统一概率；D/I属于不同模型证据类型，不代表已经验证的直接或间接作用。

#### `1_NetInfer/`

保存基于wSDTNBI方法获得的Top 50人源预测靶点、基因级结果、描述性Top 20优先层和排名汇总。平台标记为Known的参考记录单独保存，不计入NetInfer预测靶点集；NetInfer Score仅用于模型内部排序。

#### `1_COMET/`

保存COMET返回的候选靶点、评分信息和预测结合模式PDB文件。当前结果作为补充预测和来源重复核查使用；预测构象不等同于实验确认的结合模式。

#### `1_SEA/`

预留Similarity Ensemble Approach结果。当前目录为空，尚无可纳入阶段3整合的数据。

### 阶段2：AIS疾病相关靶点检索

#### `2_GeneCards/`

保存以“acute ischemic stroke”精确短语检索得到的GeneCards原始快照、完整注释表、不同Relevance Score阈值的蛋白编码基因集、Gene Symbol列表和阈值比较结果。Relevance Score是检索相关性分数，不是概率或因果证据。

#### `2_DisGenET/`

保存精确AIS疾病实体及其UMLS CUI对应的DisGeNET结果，并按原始GDA score、蛋白编码类型和文献证据形成主分析及敏感性集合。宽泛的“ischemic stroke”结果仅用于对照，不直接并入精确AIS集合。

#### `2_OMIM/`

保存OMIM MIM Match原始导出、表型筛选、人工核实的基因–表型联系、严格/主分析/扩展集合及排除审计记录。全文检索中的基因条目不能直接等同于AIS相关基因，因此只有经过表型关系核实的记录进入阶段3。

### 阶段3：多数据库标准化与证据分层

#### `3_Bilobalide/`

汇总阶段1选定的白果内酯预测结果，统一为人源标准Gene Symbol，完成全局去重、来源追踪和质量控制，形成以下集合：

| 集合 | 数量 | 用途 |
|---|---:|---|
| `Bilobalide_targets_strict_25` | 25 | 各平台严格结果的并集 |
| `Bilobalide_targets_cross_database_priority_22` | 22 | 至少获得两个选定来源支持的优先集合 |
| `Bilobalide_targets_recommended_42` | 42 | 推荐的主交集输入 |
| `Bilobalide_targets_extended_171` | 171 | 扩展探索与敏感性分析 |

其中，`Bilobalide_target_master_evidence.csv`用于追踪每个基因的预测来源和关键分数，`Bilobalide_source_manifest.csv`记录输入文件与规则，`Bilobalide_QC.csv`记录计数、重复和格式检查。多平台重复预测用于候选优先级排序，不等同于多次独立实验验证。

#### `3_AIS/`

合并GeneCards、OMIM和DisGeNET中的AIS相关蛋白编码基因，统一Gene Symbol并去重，形成以下嵌套集合：

| 集合 | 数量 | 用途 |
|---|---:|---|
| `AIS_targets_strict_28` | 28 | 严格敏感性分析 |
| `AIS_targets_primary_81` | 81 | 推荐的主交集输入 |
| `AIS_targets_medium_extended_176` | 176 | 中等扩展分析 |
| `AIS_targets_broad_sensitivity_430` | 430 | 宽口径探索性分析 |

其中，`AIS_target_master_evidence.csv`保存来源和关键证据，`AIS_source_manifest.csv`记录输入构成，`AIS_QC.csv`保存质量控制结果。疾病集合成员表示数据库关联，不表示已经确认的致病作用或治疗可行性。

### 阶段4：药物–疾病交集与PPI准备

#### `4_Intersection_PPI/00_Input/`

保存阶段3靶点集合的冻结副本和两张证据主表。`Input_manifest.csv`记录输入来源、预期与实际数量、SHA-256校验值及一致性检查结果，用于确认下游分析使用的具体版本。

#### `4_Intersection_PPI/01_Intersection/`

保存四个证据层级的白果内酯–AIS交集结果：

| 层级 | 集合定义 | 交集数量 | 定位 |
|---|---|---:|---|
| L1 Strict | Bilobalide Strict 25 ∩ AIS Strict 28 | 1 | 最高特异性敏感性层 |
| L2 Primary | Bilobalide Recommended 42 ∩ AIS Primary 81 | 2 | 预设主分析交集 |
| L3 Medium | Bilobalide Extended 171 ∩ AIS Medium 176 | 6 | 中等扩展候选层 |
| L4 Exploratory | Bilobalide Extended 171 ∩ AIS Broad 430 | 16 | 宽口径探索层 |

`Intersection_evidence_master.csv`保存16个宽口径交集基因的药物侧和疾病侧证据。`Intersection_layer_summary.csv`与`Intersection_QC.csv`用于核对层级数量、嵌套关系和数据完整性。交集基因在STRING和网络拓扑分析完成前不应称为Hub基因。

#### `4_Intersection_PPI/02_Venny/`

预留Venny交集图和复核结果。当前仅有`STATUS_NOT_EXECUTED.txt`，表示尚未执行。

#### `4_Intersection_PPI/03_STRING/`

预留STRING蛋白互作网络的输入、TSV导出、网络参数和结果文件。当前尚未执行。

#### `4_Intersection_PPI/04_Cytoscape/`

预留Cytoscape网络工程、样式和图形输出。当前尚未执行。

#### `4_Intersection_PPI/05_cytoHubba/`

预留MCC、Degree等网络拓扑算法的候选Hub排序结果。当前尚未执行。

#### `4_Intersection_PPI/06_QC_Method/`

预留PPI参数、网络质量控制、敏感性比较和方法记录。当前尚未执行。

## 常见文件类型

| 文件标识 | 含义 |
|---|---|
| `raw`、`raw_snapshot`或平台原始文件名 | 数据库或预测平台的原始导出 |
| `*_all_annotated.csv` | 保留全部记录、标准化字段和纳入/排除信息的审计表 |
| `*_strict*.csv` | 严格筛选集合 |
| `*_recommended*`、`*_primary*` | 推荐主分析集合 |
| `*_extended*`、`*_broad_sensitivity*`、`*_exploratory*` | 扩展或敏感性分析集合 |
| `*_gene_symbols*.txt` | 每行一个Gene Symbol，可直接用于集合比较或网络平台输入 |
| `*_master_evidence.csv` | 基因级跨来源证据追踪表 |
| `*_source_manifest.csv`或`Input_manifest.csv` | 数据来源、纳入规则、数量及文件校验信息 |
| `*_QC.csv` | 计数、重复、格式和层级关系检查 |
| `*_processing_notes.md` | 数据来源、清洗方式、阈值、结果解释和限制 |
| `*_processed_results.xlsx`或`*_target_sets.xlsx` | 多工作表结果汇总 |
| `STATUS_NOT_EXECUTED.txt` | 对应步骤尚未运行，不是分析结果 |

## 建议阅读顺序

1. 阅读`3_Bilobalide/Bilobalide_target_processing_notes.md`，了解药物靶点来源和分层规则。
2. 阅读`3_AIS/AIS_target_processing_notes.md`，了解疾病靶点来源和分层规则。
3. 查看两个阶段3目录中的`source_manifest`、`master_evidence`和`QC`文件，核对来源与数据质量。
4. 查看`4_Intersection_PPI/00_Input/Input_manifest.csv`，确认冻结输入及校验结果。
5. 查看`4_Intersection_PPI/01_Intersection/Intersection_processing_notes.md`、`Intersection_layer_summary.csv`和`Intersection_evidence_master.csv`，了解交集定义和证据构成。
6. 如需追溯单个平台或数据库的处理过程，再进入对应的阶段1或阶段2目录查看原始数据和`processing_notes.md`。

## 使用边界

- 不同平台评分的定义不同，不能直接相加，也不能统一解释为概率。
- 预测数据库之间可能共享训练数据或参考数据，多库命中不必然代表独立验证。
- 宽口径、扩展和探索集合用于敏感性分析，不能替代严格集或主分析集。
- STRING补充的网络邻居不属于原始药物–疾病交集靶点，后续应单独标记。
- 各数据库原始导出及衍生结果的使用应遵守对应平台的使用条款。

当前仓库未包含一键运行脚本。结果复核应以冻结输入、处理说明、证据主表、来源清单和质量控制文件为主要入口。
