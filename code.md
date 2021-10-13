# chapter2 数据文件建立和管理
## 2.1 文件读取、导入、保存
#### 2.1.1 文件读取
> `use [var] [if] [in] using filename [,clear nolabel]`  
> *use 命令若文件无扩展名，则默认读取.dat文件*
> > 可选参数 | 作用
> > ------------ | -------------
> > nolabel | 清除数据中的变量的值的标签
> > clear | 清除程序已读数据  

  
#### 2.1.2 文件导入
###### 2.1.2-1 Excel文件
> *导入整个Excel*  
>  `import excel [using] filename [,import_excel_options]`  
> *导入Excel的部分变量*  
>  `import excel extvarlist using filename [, import_excel_options]`
> > * `sheet("sheetname")` 选取工作簿
> > * `cellrange([start][:end]) ` 选取单元格
> > * `firstrow` 将第一行视为变量名
###### 2.1.2-2 纯文本文件（txt、raw、csv）
> `import delimited [using] filename [, import_delimited_options]`
> > * `delimiters("chars")` 指定分隔符
>   
> `insheet [varlist] using filename [, options]`
> > *insheet 命令被 import delimited 命令取代，虽 insheet 命令仍然继续工作，但从STATA 13开始，insheet 不再是官方的一部分*
> > * `tab` 指定tab进行分隔
> > * `comma` 指定英文逗号进行分隔  
  
##### 2.1.3 文件保存
> `save [filename] [, save_options]`
> > * `replace` 覆盖原有数据
> > * `orphans` 保存所有值标签  
  
##### 2.1.4 文件导出

##### 数据输入
> `input [var1] [var2] ...`  
> `[var1_value1] [var2_value1]`  
> `[var1_value2] [var2_value2]`  
> `... ...`  
> `end`  