# 白果内酯–急性缺血性卒中分层交集处理说明

## 处理范围

本次仅完成既定流程第1—4步：建立并冻结输入、计算四层药物–疾病交集、导出CSV/TXT、建立16基因证据追踪表。处理日期为2026-07-14。未执行Venny、STRING、Cytoscape或cytoHubba。

## 输入与标准化

输入来自`3_Bilobalide`与`3_AIS`的已冻结人源Gene Symbol集合。读取时仅执行去除首尾空格、统一大写、唯一化与字母排序；原始冻结副本不改写。全部7个集合均无重复、空行、大小写/首尾空格异常或格式异常。两张证据主表按唯一`Gene_Symbol`一对一连接。`00_Input/Input_manifest.csv`记录源路径、预期/实际计数、源文件与冻结副本SHA-256及一致性结果。

## 四层交集定义与结果

- L1_Strict：Bilobalide Strict_25 ∩ AIS Strict_28 = 1（NFKB1）。用于最高特异性敏感性分析。
- L2_Primary：Bilobalide Recommended_42 ∩ AIS Primary_81 = 2（HIF1A、NFKB1）。这是预设主分析交集，两者标记为`Core_Anchor=True`；该标记仅表示属于主分析交集，不代表实验或因果验证。
- L3_MediumExtended：Bilobalide Extended_171 ∩ AIS MediumExtended_176 = 6（F2、HIF1A、NFE2L2、NFKB1、SIRT1、TNF）。可作为后续PPI输入候选。
- L4_BroadExploratory：Bilobalide Extended_171 ∩ AIS BroadSensitivity_430 = 16。仅用于宽口径探索性敏感性分析，不得称为“最终核心靶点”。

层级关系经程序验证为L1⊆L2⊆L3⊆L4。`First_Entry_Level`为每个基因首次进入的最高置信度层级；四个`In_L*`字段是累积成员标记。

## 证据追踪

`Intersection_evidence_master.csv`恰含16行唯一Gene Symbol。每行保留UniProt/基因标识、药物预测来源及关键分数、AIS分层来源及关键分数、四层成员标记和解释限制。缺失分数保留为空值，不以0替代。

## 方法学限制

交集表示计算预测靶点与疾病关联基因的重叠，属于假设生成证据；不能据此断言直接结合、因果关系、可成药性或临床疗效。在完成STRING网络和cytoHubba排序前，任何交集基因都不应称为Hub基因。后续应预先声明使用L3（6基因）还是L4（16基因）作为PPI输入，并将另一层作为敏感性分析。
