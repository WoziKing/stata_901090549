* 第四讲 统计图绘制（初级篇）
* 1.图必有 元素
* 2./有横纵坐标的图：双变量图
* /饼状图、柱状图、直方图：单变量图
* 3.图表题（图标题在下方，表标题在上方）
* 4.图例
//经营性收入+工资性收入（付出劳动）+财产性收入（租房）+转移性收入（收礼、政府补贴）
* 5.注释/脚注（表格下方定格：数据来源，变量说明等）（note）
* 6.插文（caption）
//title //标题
//ytitle //纵轴标题
//legend //图例
***二维图：
// 散点图 csatter
// 折线图 line
// 区域图 area
// 线性拟合图 lfit
// 非线性拟合图 gfit
// 直方图 histogram
// 密度函数图 kdensity
// 函数图 function
***矩阵图
***一维图
// 柱状图 bar
// 箱型图 box
// 饼图 pie
***时序检验图
// 自相关系数图 ac
// 偏相关系数图 pac
// 脉冲响应函数图 irf
* 二维图：
* [graph] twoway (plot1) (plot2) (...) [if] [in] [, twoway_options]
* (plottype Y纵 X横 , options)
* graph save //保存图片 stata图片后缀是.gph
* graph export xxx.png
* graph use //导入图片


* 坐标轴
*   1.刻度及标签
*   2.标题
* 标题、注释、说明
*   1.类型
*   2.位置
*   3.字体大小
* 区域类
*   1.边距
* 图例
*   1.字体大小
*   2.位置
*   3.图例内容
