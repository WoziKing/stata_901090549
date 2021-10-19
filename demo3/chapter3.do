*==========================================================================*
*==========================
*第3讲 数据统计描述（初级篇）
*==========================

*-------------------------
** 观察ch3-machine数据。本数据是一个农户农机购买数据，请结合经济学理论设计一个关于农户农机购买的研究提纲。在提纲中，提出拟通过分析回答的主要问题，实证分析思路设想（包括拟用的变量、统计指标和方法）
**-----------------------

*-------------------------
*->3.1基本统计量
*--------------------------
*-3.1.1.基本描述统计指标
* summarize命令：
* 语法：summarize varlist [in] [if] [weight] [, options]
* 重要参数：detail，追加给出方差(variance)、偏度(skweness，绝对值越小，数据的正态对称性越好)、峰度(kurtosis，峰度值越大，数据的正态峰越明显)和分位数(percentiles)等统计指标。
*操作实例->
sysuse auto, clear
summarize
format price %6.2f
sum price, format
sum price weight, detail
*-3.1.2.生成统计表格
* tabstat命令：生成论文格式的统计表格，默认只报告均值。
* 语法：tabstat varlist [if] [in] [weight] [, options]
* 重要参数：by(varname)：按指定分组变量报告分组的描述性统计指标；statistics(statname [...])：报告指定的描述性统计指标。nototal不报告总体统计值，通常是与by()配合使用。
*操作实例->
sysuse auto, clear
tabstat price mpg, by(foreign) statistics(mean ma mi sd n) missing
tabstat price weight length, s(mean p25 med p75 min max) c(s) f(%6.2f) by(foreign)
*-3.1.3.描述数据内容
* codebook命令
* 语法：codebook [varlist] [if] [in] [, options]
*操作实例->
sysuse auto, clear
codebook price weight
codebook rep78 /*当一个变量中的非重复值小于9个时，Stata便会视此变量为类别变量，并列表统计*/
* inspect 命令：相对于codebook 命令，该命令还进一步绘制出直方图，以便对样本的分布有更直观的了解
*操作实例->
inspect price weight

*--------------------------------
*->3.2列联表及其描述统计
*--------------------------------
*-3.2.1.分类变量的频数分析
* tabulate/tab1命令：报告单个（多个）分类变量的频数分析结果。
* 语法1：tabulate varname [if] [in] [weight] [, options]
* 语法2：tab1 varlist [if] [in] [weight] [, options]
*操作实例->
tabulate foreign
tab1 foreign rep78 turn
*-3.2.2.列联表：考察两个分类变量的相关关系
* tabulate命令：
* 语法1：tabulate varname1 varname2 [if] [in] [weight] [, options]
* 语法2：tab2 varlist [if] [in] [weight] [, options]
* 重要参数：row按行在每个格内生成频率/比重，column按列在每个生成频率/比重，nofreq表格中不显著频数，cell在每个格内生成频率/比重。
*操作实例->
sysuse auto, clear
tab foreign rep78
tab foreign rep78, cell
tab foreign rep78, row
tab foreign rep78, column
tab2 foreign rep78 turn
*-3.2.3.列联表描述统计量
* tabulate, summarize()命令：单个或两个分类变量的描述性统计
* 语法：tabulate varname1 [varname2] [if] [in] [weight], summarize(varname3)
* 重要参数：[no] means（不）包含均值，[no] standard（不）包含标准差，[no] freq（不）包含频数，[no] obs（不）包含观测值个数。
*操作实例->
sysuse auto, clear
tabulate foreign rep78, summarize(price) means

*================================over=======================================*
