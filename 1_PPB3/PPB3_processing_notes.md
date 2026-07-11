# 白果内酯 PPB3 结果处理说明

## 输入

- 原始文件：prediction_results.csv
- 原始结果：20条（PPB3 Top 20）
- 化合物：Bilobalide，PubChem CID 73581
- 处理日期：2026-07-11
- PPB3训练数据：ChEMBL 34
- 预测模型：按照预定操作推定为Consensus；原始CSV未编码模型名称，建议保留结果页截图或另建元数据文件确认。

## 筛选规则

1. 通过ChEMBL Target API核验Target ID、物种、TaxID、target type和蛋白组分。
2. 通过UniProt核验protein accession、标准Gene Symbol和TaxID。
3. 仅保留Homo sapiens（TaxID 9606）。
4. 仅保留SINGLE PROTEIN靶点。
5. 按PPB3官方FAQ采用Confidence score >0.2；等于0.2不纳入。
6. 一个UniProt accession对应多个标准基因时，拆分为独立Gene Symbol并保留映射说明。
7. 最终按Gene Symbol去重，重复时保留Confidence score最高的记录。

## 结果

- 经核验的人源单蛋白Target记录：14条。
- 人源单蛋白基因级结果：15个基因。
- 满足Confidence score >0.2的可靠Target记录：8条。
- 最终可靠人源Gene Symbol：9个。

可靠基因集：SMN1, SMN2, ALOX15, SLCO1B3, THRB, SLCO1B1, HSD17B10, TSHR, LMNA。

PPB3结果属于DNN配体靶点预测证据，不能称为实验验证靶点。建议将可靠基因集用于药物靶点扩展，并保留PPB3来源、Confidence score和ChEMBL Target ID。
