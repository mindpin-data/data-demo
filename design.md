### 全局因素

| 项          | 值         |
| ---------- | --------- |
| 数据获取（变化频度） | 1 天（24小时） |
| 屏幕尺寸       | \>= 1080p |
| 交互方式       | 不可交互      |
| 展现方式       | 多页面轮播     |
| 总体配色       | 深底浅字      |



### 总体维度

| 维度   | 定义      |
| ---- | ------- |
| 品类   | 产品或原料种类 |
| 日期   | 数据记录日期  |
| 仓库   | 仓库位置    |
| 库存变化 | 入库或出库   |
| 预警   | 库存上限和下限 |





### 数据模型及属性



#### 企业内部变化数据（日期流水）

| 库存每日记录 | StockRecord    | 数据类型                    |
| ------ | -------------- | ----------------------- |
| 日期     | date           | Date                    |
| 品类/型号  | type           | **\<MaterialType\>**    |
| 当日入库数量 | in_amount      | Integer                 |
| 当日出库数量 | out_amount     | Integer                 |
| 当日结存数量 | balance_amount | Integer                 |
| 所在仓库   | warehouse      | **\<WarehouseDefine\>** |



| 品类库存限制 | StockLimit  | 数据类型                 |
| ------ | ----------- | -------------------- |
| 日期     | date        | Date                 |
| 品类/型号  | type        | **\<MaterialType\>** |
| 当日上限   | upper_limit | Integer              |
| 当日下限   | lower_limit | Integer              |



| 生产线输入记录 | ProductionLineRecord | 数据类型                    |
| ------- | -------------------- | ----------------------- |
| 日期      | date                 | Date                    |
| 品类/型号   | type                 | **\<MaterialType\>**    |
| 数量      | amount               | Integer                 |
| 来源仓库    | from_warehouse       | **\<WarehouseDefine\>** |



| 生产线输出记录 | ProductionLineRecord | 数据类型                    |
| ------- | -------------------- | ----------------------- |
| 日期      | date                 | Date                    |
| 品类/型号   | type                 | **\<MaterialType\>**    |
| 数量      | amount               | Integer                 |
| 去向仓库    | to_warehouse         | **\<WarehouseDefine\>** |



| 原料采购记录 | PurchaseRecord | 数据类型                    |
| ------ | -------------- | ----------------------- |
| 日期     | date           | Date                    |
| 品类/型号  | type           | **\<MaterialType\>**    |
| 数量     | type           | Integer                 |
| 来源供货商  | supplier       | **\<SupplierDefine\>**  |
| 去向仓库   | to_warehouse   | **\<WarehouseDefine\>** |
| 计划到货日期 | plan_date      | Date                    |
| 实际到货日期 | actural_date   | Date                    |



| 商品订单记录 | ProductOrderRecord | 数据类型                      |
| ------ | ------------------ | ------------------------- |
| 日期     | date               | Date                      |
| 品类/型号  | type               | **\<MaterialType\>**      |
| 数量     | type               | Integer                   |
| 去往经销商  | distributor        | **\<DistributorDefine\>** |
| 来源仓库   | from_warehouse     | **\<WarehouseDefine\>**   |
| 计划交付日期 | plan_date          | Date                      |
| 实际交付日期 | actural_date       | Date                      |







#### 固定定义类数据



| 品类定义 | MaterialType | 数据类型                     |
| ---- | ------------ | ------------------------ |
| 名称   | name         | String                   |
| 数量单位 | unit         | **\<UnitDict\>**         |
| 品类类别 | category     | **\<MaterialCategory\>** |



品类类别定义用于定义库存品类/型号的类别归属，目前取值有 [原料, 产品, 其他]

| 品类类别定义 | MaterialCategory | 数据类型   |
| ------ | ---------------- | ------ |
| 名称     | name             | String |



| 仓库定义 | WarehouseDefine | 数据类型                |
| ---- | --------------- | ------------------- |
| 名称   | name            | String              |
| 位置   | location        | **\<GeoLocation\>** |



| 供货商定义 | SupplierDefine | 数据类型                |
| ----- | -------------- | ------------------- |
| 名称    | name           | String              |
| 位置    | location       | **\<GeoLocation\>** |



| 地理位置 | GeoLocation | 数据类型             |
| ---- | ----------- | ---------------- |
| 地址描述 | address     | String           |
| 经度   | long        | Decimal          |
| 纬度   | lat         | Decimal          |
| 省    | province    | **\<DataDict\>** |
| 市    | city        | **\<DataDict\>** |
| 街道   | street      | **\<DataDict\>** |

