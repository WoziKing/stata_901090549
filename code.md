# 目录
## <a href='#chapter2'>chapter2 数据文件建立和管理</a>
   * ### <a href='#2.1'>2.1 文件读取、导入、保存</a>
       * ### <a href='#2.1.1'>2.1.1 文件读取</a>
       * ### <a href='#2.1.2'>2.1.2 文件导入</a>
           - ### <a href='#2.1.2-1'>2.1.2-1 Excel文件</a>
           - ### <a href='#2.1.2-2'>2.1.2-2 纯文本文件（txt、raw、csv）</a>
       * ### <a href='#2.1.3'>2.1.3 文件保存</a>
       * ### <a href='#2.1.4'>2.1.4 文件导出</a>
           - ### <a href='#2.1.4-1'>2.1.2-1 Excel文件</a>
           - ### <a href='#2.1.4-2'>2.1.2-2 纯文本文件</a>
   * ### <a href='#2.2'>2.2 数据查增删改</a>
       * ### <a href='#2.2.1'>2.2.1 数据查询</a>
           - ### <a href='#2.2.1-1'>2.2.1-1 数据查询列表</a>
           - ### <a href='#2.2.1-2'>2.2.1-2 数据属性查询</a>
           - ### <a href='#2.2.1-3'>2.2.1-3 数据排序</a>
       * ### <a href='#2.2.2'>2.2.2 数据增加</a>
           - ### <a href='#2.2.2-1'>2.2.2-1 数据输入增加</a>
           - ### <a href='#2.2.2-2'>2.2.2-2 新建变量</a>
       * ### <a href='#2.2.3'>2.2.3 数据删除与保留</a>
           - ### <a href='#2.2.3-1'>2.2.3-1 数据删除</a>
           - ### <a href='#2.2.3-2'>2.2.3-2 数据保留</a>
       * ### <a href='#2.2.4'>2.2.4 数据更改</a>
           - ### <a href='#2.2.4-1'>2.2.4-1 变量名更改</a>
           - ### <a href='#2.2.4-2'>2.2.4-2 值更改</a>
           - ### <a href='#2.2.4-3'>2.2.4-3 标签更改</a>
           - ### <a href='#2.2.4-4'>2.2.4-4 值标签更改</a>
           - ### <a href='#2.2.4-5'>2.2.4-5 将变量分类</a>
           - ### <a href='#2.2.4-6'>2.2.4-6 数据类型更改</a>
           - ### <a href='#2.2.4-7'>2.2.4-7 字符串型变量与数值型变量间的互换</a>
               - #### <a href='#2.2.4-7.1'>2.2.4-7.1 encode与decode</a>
               - #### <a href='#2.2.4-7.2'>2.2.4-7.2 destring与tostring</a>
<br>

***  
<br>

# <a id='chapter2'>chapter2 数据文件建立和管理</a>
## <a id='2.1'>2.1 文件读取、导入、保存</a>
### <a id='2.1.1'>2.1.1 文件读取</a>
`use [var] [if] [in] using filename [,clear nolabel]`  
*use 命令若文件无扩展名，则默认读取.dat文件*
可选参数 | 作用
------- | --------
nolabel | 清除数据中的变量的值的标签
clear | 清除程序已读数据  

### <a id='2.1.2'>2.1.2 文件导入</a>
##### <a id='2.1.2-1'>2.1.2-1 Excel文件</a>
*导入整个Excel*  
`import excel [using] filename [,import_excel_options]`

*导入Excel的部分变量*  
`import excel extvarlist using filename [, import_excel_options]`
可选参数 | 作用
------- | --------
sheet("sheetname") | 选取工作簿
cellrange([start][:end]) | 选取单元格
firstrow | 将第一行视为变量名

##### <a id='2.1.2-2'>2.1.2-2 纯文本文件（txt、raw、csv）</a>
`import delimited [using] filename [, import_delimited_options]`
可选参数 | 作用
------- | --------
delimiters("chars") | 指定分隔符  

<br>

`insheet [varlist] using filename [, options]`  
*insheet 命令被 import delimited 命令取代，虽 insheet 命令仍然继续工作，但从STATA 13开始，insheet 不再是官方的一部分*
可选参数 | 作用
------- | --------
tab | 指定tab进行分隔
comma | 指定英文逗号进行分隔  
delimiters("chars") | 指定分隔符
  
### <a id='2.1.3'>2.1.3 文件保存</a>
`save [filename] [, save_options]`
可选参数 | 作用
------- | --------
replace | 覆盖原有数据
orphans | 保存所有值标签  
  
### <a id='2.1.4'>2.1.4 文件导出</a>
##### <a id='2.1.4-1'>2.1.4-1 Excel文件</a>
`export excel [using] filename [if] [in] [, export_excel_options]`
##### <a id='2.1.4-2'>2.1.4-2 纯文本文件</a>
`outfile [varlist] using filename [if] [in] [, options]`
  
<br>

## <a id='2.2'>2.2 数据查增删改</a>
### <a id='2.2.1'>2.2.1 数据查询</a>
##### <a id='2.2.1-1'>2.2.1-1 数据查询列表</a>
`list [varlist] [if] [in] [, options]`
##### <a id='2.2.1-2'>2.2.1-2 数据属性查询</a>
`describe [varlist], [simple/short]`  
`describe [varlist] using filename, [simple/short]`
##### <a id='2.2.1-3'>2.2.1-3 数据排序</a>
`gsort [-] varname [[-] varname …] [, generate (newvar) mfirst]`
  
### <a id='2.2.2'>2.2.2 数据增加</a>
##### <a id='2.2.2-1'>2.2.2-1 数据输入增加</a>
`input [var1] [var2] ...`  
`[var1_value1] [var2_value1] ...`  
`[var1_value2] [var2_value2] ...`  
`... ... ...`  
`end`  
*适合小样本数据*
##### <a id='2.2.2-2'>2.2.2-2 新建变量</a>
`generate [type] newvar=exp [if] [in]`  
*exp为新变量生成的规则，数学表达式*
  
### <a id='2.2.3'>2.2.3 数据删除与保留</a>
##### <a id='2.2.3-1'>2.2.3-1 数据删除</a>
`drop varlist`
##### <a id='2.2.3-2'>2.2.3-2 数据保留</a>
`keep varlist`
  
### <a id='2.2.4'>2.2.4 数据更改</a>
##### <a id='2.2.4-1'>2.2.4-1 变量名更改</a>
`rename old_var new_var`  
`rename (old1 old2 ...) (new1 new2 ...)`  
*t\*代表以t开头的变量*
##### <a id='2.2.4-2'>2.2.4-2 值更改</a>
`replace oldvar=exp [if] [in] [, nopromote]`
##### <a id='2.2.4-3'>2.2.4-3 标签更改</a>
*定义数据标签*  
`label data "label"`  
*定义变量标签*  
`label var varname "label"`
##### <a id='2.2.4-4'>2.2.4-4 值标签更改</a>
*定义值变量标签*  
`label define lblname # "label" [# "label" ...] [, add modify replace nofix]`  
*将值标签指定到分类变量上*  
`label values varlist [lblname|.] [, nofix]`  
*删除值标签*  
`label drop {lblname [lblname ...] | _all}`
##### <a id='2.2.4-5'>2.2.4-5 将变量分类</a>
`recode varlist (rule) [(rule) ...] [, generate(newvar)]`  
*示例：`recode leng (142/170 = 1 "A级车") (171/204 = 2 "B级车") (205/233 = 3 "C级车") ,generate(lengtype)`*
##### <a id='2.2.4-6'>2.2.4-6 数据类型更改</a>
`format varlist %fmt`  

整数数据类型  
数据类型 | 含义 | 范围   
------- | -------- | -------   
byte | 字节型 | (-100,+100)  
int | 一般整数型 | (-32000,+32000)  
long | 长整型 | (-2.14\*10^10, +2.14\*10^10) 
  
小数数据类型  
数据类型 | 含义 | 精度  
------- | -------- | -------  
float | 浮点型 | 8位有效数字  
double | 双精度型 | 16位有效数字  
  
字符串数据类型  
数据类型 | 含义 | 大小  
------- | -------- | -------  
str | 字符串型 | # 
  
##### <a id='2.2.4-7'>2.2.4-7 字符串型变量与数值型变量间的互换</a>
###### <a id='2.2.4-7.1'>2.2.4-7.1 encode与decode</a>
*字符串——>数值*  
`encode varname [if] [in], generate(newvar) [label (name) noextend]`  
*数值——>字符串*  
`decode varname [if] [in], generate(newvar) [maxlength(#)]`  
###### <a id='2.2.4-7.2'>2.2.4-7.2 destring与tostring</a>
*字符串——>数值*  
`destring [varlist] , {generate(newvarlist)|replace} [destring_options]`  
*数值——>字符串*  
`tostring varlist , {generate(newvarlist)|replace} [tostring_options]`  