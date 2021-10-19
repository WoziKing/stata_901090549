* 3.1基本统计量
* 3.1.1 基本描述统计指标（sum）
* summarize varlist
*   ,detail 报告额外信息
*       skweness 偏度（正态）
*       kurtosis 峰度（正态）
* tabstat var ,statistics() 报告具体统计指标
* codebook 简单观察数据变量
* inspect 生成分布简单直方图
* 3.2.2 列联表
* tabulate var //频数分析（tab）
* tab1 varlist //对每一个变量单独做频数分析
* tab var1 var2 //列联分析
* tab2 var1 var2 var3 ..... //两两生成
*   ,col //列加总是100%
*   ,row //行加总是100%
*   ,nofreq //无频数
* tabulate var ,summarize(var2)   //var2 连续变量