*========================
*第4讲 统计图绘制（初级篇）
*========================
*--------------------
*->4.1图形范例
*--------------------
*操作实例->
infile str14 country setting effort change using https:
//data.princeton.edu/wws509/datasets/effort.raw, clear
gen pos=3
replace pos = 11 if country == "TrinidadTobago"
replace pos = 9 if country == "CostaRica"
replace pos = 2 if country == "Panama" | country == "Nicaragua"
twoway (lfitci change setting) (scatter change setting, mlabel(country) mlabv(pos) ), ///
title("Fertility Decline by Social Setting") ytitle("Fertility Decline") ///
legend(ring(0) pos(5) order(2 "linear fit" 1 "95% CI"))
graph export fig31.png, width(500) replace

*------------------
*->4.2简介
*------------------
*-4.2.1.图形的元素构成和种类
* （1）图形的六大元素：曲线（点/线/面）、标题与副标题、图例、脚注、插文、坐标轴
*stata数据可视化超牛的网站https://www.surveydesign.com.au/tipsgraphs.html
*每种图形的具体特征由元素的特征决定：参数选项。选项的填写是Stata绘图的关键！
* （2）图形的种类：
* （a）二维图：常见有散点图scatter、折线图line、区域图area、线性拟合图lfit、非线性拟合图qfit、直方图histogram、密度函数图kdensity、函数图function；
* （b）矩阵图
* （c）一维图：常见有柱状图（bar）、箱形图（box）、饼图（pie）
* （d）时序检验图：常见有自相关系数图ac、偏相关系数图pac、脉冲相应函数图irf；
*部分图形的简单示例->
sysuse sp500, clear
*-散点图
twoway scatter high date
*-折线图
twoway line change date
*-柱状图
twoway bar open date in 1/50
*-直方图
histogram change
*-密度函数图
kdensity close, normal
*-数学函数图
twoway (function y=sin(x), range(-10 10) lw(*1.5)) ///
(function y=cos(x), range(-10 10) lw(*2.0)), ///
ytick(-2(0.5)2) ylabel(, angle(0)) ///
yline(0, lcolor(black*0.5) lpattern(dash)) ///
scheme(s1mono)
*-4.2.2.二维图命令的基本结构
* （1）整体架构
* 语法1：[graph] twoway (plot1) (plot2) (…) [if] [in] [, twoway_options]
* 语法2：[graph] twoway plot1 || plot2 || … [if] [in] [, twoway_options]
* （2）单元图定义： (plottype varlist, [options])
* （3）参数选项的定义 //4.3节有详细解释
*如，二维图选项标题 (定义内容 , 子选项 子选项 ...)
*操作实例->
sysuse sp500, clear
twoway (line high date) (line low date) ///
, /// 
title("图1：股票最高价与最低价时序图", box) ///
xtitle("交易日期", margin(medsmall)) ///
ytitle("股票价格") ///
ylabel(900(200)1400) ymtick(##5) ///
legend(label(1 "最高价") label(2 "最低价")) ///
note("资料来源：Stata公司，SP500.dta") ///
caption("说明：我做的第一幅Stata图形！") ///
saving(mypig.gph, replace)
*^-^ 注意：逗号后全部为选项，裸露在外的逗号只有一个
*-4.2.3.图形的保存或导出
* （1）graph save命令：图形保存
* 语法：graph save [graphname] filename [, asis replace]
*操作实例->
sysuse sp500, clear
twoway line high low date
graph save fig1.gph, replace
* （2）graph export命令：图形导出。相当于另存为其它格式的图形
* 语法：graph export newfilename.suffix[, options]
*操作实例->
sysuse sp500, clear
twoway line high low date
graph export fig2a.wmf, replace
*^-^注意：一些常用的图形保存类型
* 后缀 附加选项 输出格式
*------------------------------------------------------------
* .ps as(ps) PostScript
* .eps as(eps) Encapsulated PostScript
* .wmf as(wmf) Windows Metafile
* .emf as(emf) Windows Enhanced Metafile
* .pict as(pict) Macintosh PICT format
* .png as(png) PNG (Portable Network Graphics)
* .tif as(tif) TIFF
*------------------------------------------------------------
* 调整输出图片的分辨率：仅适用于 .png 和 .tif 格式的图片
*操作实例->
twoway line high low date
graph export fig2b.tif, width(3160) height(1800) replace
shellout fig2b.tif //输出到windows照片查看器查看图片
*-4.2.4.图形的调入
* graph use命令
*操作实例->
graph use fig1.gph
graph use fig1, scheme(s1mono) //scheme()定义图形显示模式
graph use fig1, scheme(economist)
*-4.2.5.图片的查询
* graph dir命令
*-4.2.6.重新显示图形
* graph display命令
*操作实例->
twoway line high low date
graph display, scheme(sj)
graph save fig3.gph, replace
*-4.2.7.图形的合并
* graph combine命令
*操作实例->
graph combine fig1.gph fig3.gph
*-4.2.8.删除图形
*操作实例->
erase fig3.gph
graph dir
*-4.2.9.图形的显示模式(绘图模板)
* （1）显示模式种类
help schemes // Stata 提供的显示模式
* （2）图形显示模式设定
* 语法1：set scheme schemename [, permanently]
* 语法2：graph ... [, ... scheme(schemename) ...]
*操作实例->
sysuse auto, clear
twoway scatter price weight, scheme(sj)
graph save price1.gph, replace
graph use price1.gph, scheme(s2color)
set scheme economist
twoway scatter price weight
* （3）中文投稿的黑白图
*操作实例->
set scheme s1mono
sysuse auto, clear
twoway scatter price weight
graph bar price, over(foreign)
graph bar price, over(rep78) over(foreign)
sysuse sp500, clear
twoway (connect high date,sort msymbol(D)) ///
(connect low date, msymbol(+)) in 1/20 ///
, scheme(s1mono)
* （4）stata用户提供的模板
*Mitchell 提供的模板
view browse "http://www.stata-press.com/data/vgsg.html"
net from http://www.stata-press.com/data/vgsg2/
net install vgsg2 // 安装外部模式插件
net get vgsg2 // 下载相关数据
*操作实例->
sysuse allstates.dta, clear
twoway scatter propval100 rent700 ownhome, ///
scheme(vg_s1c) // vg_s1c 黑白底，彩色图
twoway scatter propval100 rent700 ownhome, ///
scheme(vg_s1m) // vg_s1c 黑白底, 黑白图
*Roger Newson 提供的模板
net install scheme_rbn1mono
help scheme_rbn1mono
*操作实例->
sysuse allstates.dta, clear
twoway scatter propval100 rent700 ownhome, scheme(s1mono) // stata默认模式
twoway scatter propval100 rent700 ownhome, scheme(rbn1mono) //rbn1模式
twoway scatter propval100 rent700 ownhome, scheme(rbn1mono) ///
xlabel(,angle(0)) legend(row(1))

*----------------------------------------------------------
*->4.3二维图的参数选项
*----------------------------------------------------------
help twoway_options
*-4.3.1.坐标类
help axis_options
* （1）坐标轴刻度(tick)及刻度标签(label)
help axis_label_options
*（a）主刻度及标签：ylabel(), xlabel() // 显示刻度标签时，同时显示刻度
*（b）主刻度： ytick(), xtick() // 按设定显示刻度，仅显示主要刻度的标签
*（c）子刻度及标签：ymlabel(), xmlabel()
*（d）子刻度： ymtick(), xmtick()
*操作实例->
set scheme s2color
sysuse auto, clear
scatter mpg weight, xlabel(#10) // 显示出来的刻度标签未必是10个，?
scatter mpg weight // Stata 默认设定，比较宽松
scatter mpg weight, xlabel(#10) // 在横坐标上列示10个最佳的刻度及其标签
scatter mpg weight, xtick(#10)
scatter mpg weight, ///
ylabel(10(5)45) ///
xlabel(1500 2000 3000 4000 4500 5000) // 自行设定刻度标签
scatter mpg weight, ymlabel(##5) xmtick(##10) // 子刻度和子刻度标签
scatter mpg weight, xlabel(1500 2500 3190 "中位数" 3500 4500)
// 刻度标签由`数字'替换为`文字' 
*参数设定规则：
* rule example description
*--------------------------------------------------------------
* #? #4 4 个最佳值
* ##? ##10 10-1=9 个子刻度列印于主刻度之间
* 仅适用于 mlabel() 和 mtick() 选项
* ?(?)? 10(5)45 在 10 到 45 范围内，每隔 5 列印一个子刻度
* none none 不显示刻度标签
*--------------------------------------------------------------
*（e）刻度标签的角度（详见文字选项部分）
scatter mpg weight, xlabel(, angle(45)) ylabel(, angle(-15))
* （2）坐标轴标题：ytitle() xtitle()
help axis_title_options
sysuse auto, clear
scatter mpg weight, ytitle("汽车里数") xtitle("汽车重量")
*（a）坐标轴标题的位置
scatter mpg weight, ytitle("汽车里数", place(top)) ///
xtitle("汽车重量", place(right))
*（b）长标题的处理
scatter mpg weight, xtitle("汽车里数" "(mpg)")
* （3）坐标结构：yscale() xscale()
help axis_scale_options
*（a）显示范围的控制
scatter mpg weight
scatter mpg weight, xscale(range(0 5000)) xlabel(0(1000)5000)
scatter mpg weight, xscale(range(1000 6000))
scatter mpg weight, xscale(range(3000 4000)) //为何不奏效？
scatter mpg weight if (wei>=3000&wei<=4000) // 局部显示需要用if语句
*（b）坐标轴标题间距的控制
label var mpg "汽车里数"
label var weight "汽车重量"
scatter mpg weight , xlabel(#14) // 默认设置
scatter mpg weight, xscale(titlegap(2)) // 坐标轴与坐标轴标题间距
scatter mpg weight, xscale(titlegap(2) outergap(-2)) // 坐标轴标题下边距
*（c）坐标轴的显示
scatter mpg weight, yscale(noline) xscale(noline) //不显示坐标轴
scatter mpg weight, yscale(off) xscale(off) //不显示坐标轴和刻度标签
scatter mpg weight, yscale(off) xscale(off) plotregion(style(none)) //无边距
scatter mpg weight, xscale(lcolor(red) lwidth(vthick)) //坐标轴线型
* （4）双坐标系
help axis_choice_options
*（a）共用 x 轴
sysuse sp500, clear
twoway line close change date
twoway (line close date, yaxis(1)) ///
(line change date, yaxis(2))
twoway (line close date, yaxis(1)) ///
(line change date, yaxis(2)), ///
ylabel(-50(10)40, axis(2) angle(0) labsize(small))
*（b）单独的 y 轴和 x 轴
twoway (line close date, yaxis(1) xaxis(1)) ///
(line change date, yaxis(2) xaxis(2)), ///
ylabel(-50(10)40, axis(2)) ///
xlabel(15005 15239, axis(2)) ///
xtitle("", axis(2))
*-4.3.2.标题类
* （1）标题的种类
*主标题、副标题、注释、说明
* title()、subtitle()、note()、caption()
help title_options
*操作实例->
sysuse auto, clear
scatter mpg weight, title("Mileage and weight")
scatter mpg weight, title("Mileage and weight", box)
scatter mpg weight, title("Mileage and weight", box bexpand)
scatter mpg weight, title("主标题") subtitle("副标题")
scatter mpg weight, title("主标题") ///
subtitle("副标题") ///
note("注释内容") ///
caption("进一步的说明")
scatter mpg weight, title("汽车里数和重量的" "散点图") ///
subtitle("——美国资料实例")
* （2）标题的位置
*^-^说明：本节内容同样适用于包含legend()选项的类目
*默认位置：tile/subtitle居中，note/caption左对齐
*重新定位：position()的取值，以时钟平面的小时刻度位置来标记
*默认相对间距：ring()的取值，0表示在绘图区内，值越大，离绘图区越远
*操作实例->
scatter mpg weight, title("汽车里数和重量",position(5))
scatter mpg weight, title("汽车里数和重量",position(3) ring(0))
scatter mpg weight, title("汽车里数和重量",position(3) ring(12))
*-4.3.3.区域类
help region_options
* （1）Stata图形的区域划分
*操作实例->
sysuse auto, clear
scatter mpg weight, ///
graphregion(fcolor(green*0.8)) ///
graphregion(ifcolor(yellow)) ///
plotregion(fcolor(black*0.3)) /// 
plotregion(ifcolor(white)) ///
title("Title：全图内区 (inner graph region)") ///
xtitle("Xtitle：汽车重量") ///
ytitle("Ytitle: 汽车里数") ///
note("Note：(1) 灰色部分称为“绘图外区”(outer plot region)" ///
" (2) 绿色部分称为“全图外区”(outer graph region)") ///
caption("Caption：各区域的面积决定于显示模式(scheme)和内容的多少") ///
text(30 3500 "绘图内区 (inner plot region)", ///
color(blue) size(*1.5))
* （2）控制内区和外区的边距
*操作实例->
twoway function y=x
twoway function y=x, plotregion(fcolor(green*0.4)) ///
plotregion(ifcolor(white))
twoway function y=x, plotregion(margin(0)) // 图形真正从原点开始出发
twoway function y=x, graphregion(margin(0))
twoway function y=x, plotregion(margin(l+15 r+5 t=10 b+4))
/*四个边距可以分别控制*/
* （3）控制图形的纵横比例
twoway function y=x, ysize(5) xsize(5)
* （4）绘图区的显示模式
twoway function y=x, plotregion(style(none))
twoway function y=x, plotregion(style(ci2))
* （5）绘图区和全图区背景颜色的控制
*操作实例->
sysuse auto, clear
scatter mpg weight, graphregion(fcolor(green*0.8)) ///
graphregion(ifcolor(yellow)) ///
plotregion(fcolor(black*0.3)) /// 
plotregion(ifcolor(white)) ///
title("Stata图形分成四个区域")
*-4.3.4.图例类
help legend_options
* （1）自动产生的图例
*一张图中同时呈现多个序列，便会自动产生图例
*对于变量而言，其默认图例是它的变量标签
*操作实例->
sysuse sp500, clear
twoway (line high date) (line low date) // 如何加入中文图例？
sysuse auto, clear
twoway (scatter price weight if foreign==1) ///
(lfit price weight if foreign==1) ///
(scatter price weight if foreign==0) ///
(lfit price weight if foreign==0)
* （2）重新定制图例
*（a）第一种方式：预先定义变量标签。
*操作实例->
sysuse sp500, clear
label var high 最高股价
label var low 最低股价
twoway (line high date) (line low date)
*-缺点：会永久改变变量标签
*（b）第二种方式：每个图单独加图例
*操作实例->
sysuse sp500, clear
twoway (line high date,legend(label (1 "最高价"))) ///
(line low date, legend(label (2 "最低价")))
*（c）第三种方式：整体加图例
twoway line high date || line low date, ///
legend(label(1 "最高价") label(2 "最低价"))
*（d）不显示图例 legend(off)
twoway (line high date) (line low date), legend(off)
* （3）图例的位置
*（a）legend 的默认位置是ring(3)
*（b）改变legend()的相对位置
*绘图区`外'的时钟点上
twoway line high date || line low date, ///
legend(position(12))
*绘图区`内'的时钟点上ring(0)
twoway line high date || line low date, ///
legend(ring(0))
twoway line high date || line low date, ///
legend(position(12) ring(0))
*（c）note()的默认位置是 ring(4)
*（d）caption()的默认位置是 ring(5)
twoway line high date || line low date, ///
note("addad") caption(资料来源：Stata公司)
twoway line high date || line low date, ///
caption(资料来源：Stata公司, ring(3)) ///
legend(ring(5))
* （4）多个图例的重排rows(#), cols(#) 选项
sysuse uslifeexp.dta, clear
line le le_w le_b year
line le le_w le_b year, legend(rows(1))
line le le_w le_b year, legend(cols(1) size(small))
* （5）线型的控制
help connect_options
help linepatternstyle
help linestyle
*操作实例->
sysuse sp500, clear
twoway connect open close low date in 1/10
twoway connect open close low date in 1/10, ///
lpattern(solid dash longdash)
twoway connect open close low date in 1/10, ///
lpattern(solid dash longdash) ///
scheme(s1mono) // 黑白图片
*-4.3.5.附加线类
help added_line_options
*-说明：本节中介绍的附加线属性，适用于所有与线相关的对象
* （1）选项结构
*twoway ..., yline(数字, 子选项)
* twoway ..., xline(数字, 子选项)
*-数 字： 控制附加线的位置
*-子选项：控制附加线的类型、颜色、宽度等
* （2）附加线 <位置>
sysuse sp500, clear
line open date, yline(1100)
line open date, yline(1100 1313) xline(15242)
* （3）附加线 <风格>
* defult 决定于显示模式(set scheme)
* extended 延伸到绘图外区
* unextended 不延伸到绘图外区
line open date, yline(1100, style(unextended))
*操作实例（参数变化对比）->
line open date, yline(1100, style(unextended)) ///
plotregion(fcolor(green*0.3)) ///
plotregion(ifcolor(white))
line open date, yline(1100) ///
plotregion(fcolor(green*0.3)) ///
plotregion(ifcolor(white))
* （4）附加线 <线宽>
help linewidthstyle
line open date, yline(1100, lwidth(thick)) // 采用代号设定
line open date, yline(1100, lwidth(*1.5)) // 设定相对宽度
* （5）附加线 <颜色>
graph query colorstyle
line open date, yline(1100, lcolor(blue))
line open date, yline(1100, lcolor(blue*0.3))
* （6）附加线 <线型>
help linepatternstyle
palette linepalette
line open date, yline(1100, lpattern(dash) lcolor(black*0.3))
line open date, yline(1100, lpattern(dot))
* （7）附加线属性的独立性
line open date, yline(1100,lp(shortdash_dot) lc(blue*0.6)) ///
yline(1313,lw(*2.5) lc(green*0.4)) ///
xline(15242,lw(*2) lc(pink*0.4) lp(longdash))
*-4.3.6.文字与文本框
help textbox_options
help textstyle
help textboxstyle
*指点迷津：想想word 中的文本框
*凡是出现文字的地方都可以做下面的设定
* （1）选项类别
*文字和文本框的整体风格：标题、副标题、文本、小号
*文本框相关设定：文本框颜色、背景、与文字的边距等
*文字相关的设定：大小、颜色、位置、行距
* （2）文字和文本框的整体风格
*-文字的风格: 文字的标准化大小
help textstyle
*-文本框的风格
help textboxstyle
line open date, title("SP500 开盘价", tstyle(subheading))
*-文字与文本框的区别：
* 文字： 单行，无边框
* 文本框：单行或多行，可加边框，是文字的更一般化定义
* （3）文本框属性
*-显示文本框
line open date, title("SP500 开盘价", box)
*-文本框的相对大小
line open date, title("SP500 开盘价", box width(60) height(15))
*-文本框的背景和边框的颜色
line open date, title("SP500 开盘价", box fcolor(blue*0.2)) //仅背景
line open date, title("SP500 开盘价", box bcolor(yellow*0.4)) //背景和边框
line open date, title("SP500 开盘价", box fc(blue*0.2) lc(red))
*-边框的粗细、线型
line open date, title("SP500 开盘价", box fc(yellow*0.2) ///
lc(green) lwidth(*2.5) lpattern(dash))
*-文字与边框的相对位置
line open date, title("SP500 开盘价", box width(60) height(15) ///
alignment(middle)) // 纵向定位
line open date, title("SP500 开盘价", box width(60) height(15) ///
justification(right)) // 横向定位
* （4）文字属性
*-文字位置
help compassdirstyle
*控制标题等位置: place()
line open date, xtitle("交易日期", place(right)) ///
ytitle("开盘价格", place(top))
*在图形中的特定坐标点添加文字
line open date, text(1324.83 15117 "一个波峰")
*-文字的角度
help anglestyle
line open date
line open date, xlabel(, angle(30)) ylabel(,angle(0))
line open date, xlabel(, angle(30)) ylabel(,angle(15)) ///
ymlabel(##4,angle(15))
*-文字大小
help textsizestyle
line open date, text(1324.83 15117 "一个波峰",size(huge)) // 绝对大小
line open date, text(1324.83 15117 "一个波峰",size(*1.6)) // 相对大小
*-文字颜色
help colorstyle
line open date, text(1324.83 15117 "一个波峰",color(blue))
line open date, text(1324.83 15117 "一个波峰",color(black*0.4))
*-文字行距
line open date, ///
note("SP500指数的时序图""(在此期间，股市两次大跌！)", ///
color(blue))
line open date, ///
note("SP500指数的时序图""(在此期间，股市两次大跌！)", ///
color(blue) linegap(2.5))
*-4.3.7.图标类
help markerlabelstyle
help marker_options
help marker_label_options
* （1）简介
*-命令结构： twoway (单元图) , mlabel(文字变量) 其他选项
sysuse lifeexp, clear
do “c:\soft&photo\teach\4经济统计分析软件应用\ppt-硕博\初级视频配套资料\Net_course_A\A3_graph\A3_mlabel.do”
list lexp gnppc country2 if region==2
scatter lexp gnppc if region==2, mlabel(country2)
* （2）图标的位置
*-整体设定
scatter lexp gnppc if region==2, ///
mlabel(country2) mlabposition(9)
scatter lexp gnppc if region==2, ///
mlabel(country2) mlabp(3)
*-个别设定
gen pos = 3
replace pos = 4 if country2=="美国"
replace pos = 1 if country2=="宏都拉斯"
scatter lexp gnppc if region==2, ///
mlabel(country2) mlabvp(pos)
scatter lexp gnppc if region==2, ///
mlabel(country2) mlabvp(pos) ///
xscale(range(-2000 33000))
* （3）图标的大小
*-标准化大小
help textstyle
scatter lexp gnppc if region==2, ///
mlabel(country2) mlabvp(pos) ///
mlabtextstyle(heading)
*-任意大小
help textsizestyle
scatter lexp gnppc if region==2, ///
mlabel(country2) mlabvp(pos) ///
mlabsize(vsmall)
scatter lexp gnppc if region==2, ///
mlabel(country2) mlabvp(pos) ///
mlabsize(*0.7) // 推荐采用此法！
* （4）图标的角度
*可以是任意数值
*0 水平 90 竖直
help anglestyle
scatter lexp gnppc if region==2, ///
mlabel(country2) mlabvp(pos) ///
mlabangle(15)
scatter lexp gnppc if region==2, ///
mlabel(country2) mlabvp(pos) ///
mlabangle(-15) ///
xscale(range(35000) log)
help axis_scale_options
* （5）图标的颜色
help colorstyle
scatter lexp gnppc if region==2, ///
mlabel(country2) mlabvp(pos) ///
mlabcolor(green)
*-4.3.8.其它选项
* （1）分组绘图
help by_option
sysuse auto, clear
scatter mpg weight, by(foreign)
scatter mpg weight, by(foreign, total)
scatter mpg weight, by(foreign, total rows(1))
scatter mpg weight, by(foreign, total cols(1))
scatter mpg weight, by(foreign, total cols(1) style(compact))
*操作实例->
use comp2001ts, clear
browse
reshape long price, i(date) j(compname) string
browse
#delimit ; // 彩色图形
twoway tsline price ,
by(compname, cols(1) yrescale note("") compact)
ylabel(#2, nogrid)
title(" ", box width(130) height(.001) bcolor(ebblue))
subtitle(, pos(5) ring(0) nobexpand nobox color(red))
scheme(s2color) ;
#delimit cr
#delimit ; // 黑白图形
twoway tsline price ,
by(compname, cols(1) yrescale note("") compact)
ylabel(#3, nogrid)
title(" ", box width(130) height(.001) bcolor(black*0.3))
subtitle(, pos(5) ring(0) nobexpand nobox color(black))
scheme(s1mono) ;
#delimit cr
* （2）重新设置变量标签
help advanced_options
sysuse sp500, clear
twoway line close date, ///
yvarlabel("收盘价") xvarlabel("交易日期")
twoway line high low date, ///
yvarlabel("最高价" "最低价") ///
xvarlabel("交易日期")
* （3）重新设置变量显示格式
help advanced_options
twoway line high date, xvarformat(%tdY-n-d) yvarformat(%6.2f)
* （4）重设图形种类
twoway line change date, recast(area)
twoway area change date
twoway (line change date if change>0, recast(spike)) ///
(line change date if change<0, recast(area))
twoway (line change date, recast(area) color(blue)) ///
(line change date if abs(change)<15, recast(area) color(red)), ///
legend(label(1 "|change|>=15") label(2 "|change|<15"))
twoway function y=normalden(x), range(-4 4)
twoway function y=normalden(x), range(-4 4) recast(spike)
twoway (function y=normalden(x), range(-4 4)) ///
(function y=normalden(x), range(-4 -1.96) ///
recast(area) color(black*0.4)) ///
(function y=normalden(x), range(1.96 4) ///
recast(area) color(black*0.4)), ///
legend(off)
*-示例：彩色花瓣
do “c:\soft&photo\teach\4经济统计分析软件应用\ppt-硕博\初级视频配套资料\Net_course_A\A3_graphA3_area02.do”

*------------------------
*->4.4元素代号
*------------------------
*-4.4.1.颜色代号
help colorstyle
graph query colorstyle
* （1）显示特定的颜色
palette color blue brown
palette color olive dkorange
* （2）颜色模板
palette_all // 外部命令
palette_all, b(white) // 指定背景，便于对比
palette_all, b(black)
vgcolormap // 外部命令,效果更佳
clear
full_palette // 外部命令，附加 RGB 代码, 66 种颜色
browse
* （3）调制自己喜欢的颜色
* 代码格式 调色方式
* ---------------------------------------------------------
* # # # RGB value; white = "255 255 255"
* # # # # CMYK value; yellow = "0 0 255 0"
* color*# color with adjusted intensity; yellow*1.2
* *# default color with adjusted intensity
* ---------------------------------------------------------
*-三个基准色： 
*red = 255 0 0
*green = 0 255 0
*blue = 0 0 255
*-RGB 与 CMYK 之间的转换
colortrans 255 0 0
colortrans 0 255 255 0
ret list
*-4.4.2.线相关的代号
help lines
help line_options
* （1）线型代号
help linepatternstyle
help linestyle
palette linepalette // 图示
graph query linepatternstyle // 列示代码
twoway function y=normalden(x), range(-4 4) lpattern(longdash)
* （2）线宽代号
help linewidthstyle
graph query linewidthstyle
twoway function y=normalden(x), range(-4 4) lwidth(vthick)
* （3）连接方式代号
help connectstyle
graph query connectstyle
twoway function y=normalden(x), range(-4 4) n(50) ///
connect(stepstair)
*-4.4.3.标记符号的代号
help symbolstyle
palette symbolpalette
* （1）符号样式
sysuse auto, clear
twoway (scatter price weight if foreign, msymbol(T)) ///
(scatter price weight if !foreign, msymbol(dh)), ///
legend(label(1 "国产") label(2 "进口"))
*另一种语法格式
sysuse sp500, clear
twoway scatter high low date, msymbol(oh dh)
* （2）符号的边界和填充
* mlcolor()：边界颜色； mfcolor(): 填充颜色
sysuse auto, clear
scatter mpg weight, msymbol(O) mlcolor(green) mfcolor(yellow*0.5)
* （3）符号代号一览
help showmarkers
showmarkers, over(msymbol)
showmarkers, over(msymbol) msize(large)
showmarkers, over(msize)
showmarkers, over(mcolor) // 边界颜色
showmarkers, over(mfcolor) // 填充颜色
showmarkers, over(mlcolor) mfcolor(gray) ///
msize(large) mlwidth(medthick)
showmarkers, over(mlwidth) mfcolor(gray) ///
msize(large) mlcolor(navy)
showmarkers, over(msymbol) scheme(s1mono)
showmarkers, over(msymbol) msize(large) ///
scheme(s1mono)
*-4.4.4.文字相关的代号
* （1）文字大小代号
help textsizestyle
* （2）文字角度代号
help anglestyle
* （3）文字对齐方式的代号
help justificationstyle // 左右对齐方式
help alignmentstyle // 上下对齐方式
*-4.4.5.边距大小的代号
help marginstyle
*---------------------关于代号的一个说明-------------------------
* 多数情况下，Stata都支持相对数值，为我们提供了一种便捷的设定方式
* 如, text("文字",size(*0.5) 
* color(green*0.3))
* xline(30, lwidth(*1.5))

*--------------------------
*->4.5常用图形示例
*--------------------------
*-4.5.1.散点图
help twoway scatter
*操作实例->
sysuse uslifeexp2, clear
#delimit ;
scatter le year,
title("图1: 散点图示例")
subtitle("预期寿命, 美国")
yvarlabel(预期寿命)
xvarlabel(年份)
note("1")
caption("数据来源: 美国国家重要统计资料报告,第5卷-第6期")
scheme(economist);
#delimit cr
*-4.5.2.折线图
help line
*^-^注意：需要对 x 变量排序
sysuse auto, clear
line mpg weight
line mpg weight, sort
*操作实例->
sysuse uslifeexp, clear
gen diff = le_wmale - le_bmale
label var diff "寿命差异"
#delimit ;
twoway (line le_wmale year, yaxis(1 2) xaxis(1 2)) (line le_bmale year) (line diff year),
ylabel(0 20(10)80, gmax angle(0))
ylabel(0(5)20, axis(2) gmin angle(0))
xlabel(1918, axis(2)) ///
title("图2：白人和黑人预期寿命")
subtitle("美国, 1900-1999")
ytitle("预期寿命 (年)")
xtitle("年份")
ytitle("", axis(2))
xtitle("", axis(2))
note("数据来源: 美国国家重要统计资料报告, 第5卷-第6期"
"(1918 巨降: 源于1918年全国性流行感冒)",linegap(1.2))
legend(label(1 "白人男性") label(2 "黑人男性")
rows(1) size(*0.7));
#delimit cr
*-4.5.3.区域图
help twoway area
*事实上是折线图的变形，无非是在折线下方的区域内涂上颜色而已！
*操作实例1->
sysuse gnp96, clear
twoway line d.gnp96 date, yline(0,lc(black*0.4) lp(dash))
twoway area d.gnp96 date
*操作实例2->
#delimit ;
twoway area d.gnp96 date,
xlabel(36(8)164, angle(45))
ylabel(-100(50)200, angle(0))
ytitle("Billions of 1996 Dollars")
xtitle("")
subtitle("Change in U.S. GNP", position(11))
note("Source: U.S. Department of Commerce,Bureau of Economic Analysis") ;
#delimit cr
*-4.5.4.钉形图
help twoway spike // 简单钉形图
help twoway rspike // 区域钉形图
*多用于股票数据
sysuse sp500, clear
twoway spike high date
twoway rspike high low date
twoway (rspike hi low date) (line close date) in 1/57
*操作实例1->
sysuse sp500, clear
replace volume = volume/1000
#delimit ;
twoway (rspike hi low date)
(line close date)
(bar volume date, barw(.25) yaxis(2))
in 1/57
,
yscale(axis(1) r(900 1400))
yscale(axis(2) r( 9 45))
ylabel(, axis(2) grid)
ytitle("股价 -- 最高, 最低, 收盘",place(top))
ytitle("交易量 (百万股)", axis(2) bexpand just(left))
xtitle(" ")
legend(off)
subtitle("S&P 500", margin(b+2.5))
note("数据来源: 雅虎财经！");
#delimit cr
*操作实例2->
sysuse sp500, clear
replace volume = volume/10000
twoway (rarea high low date) ///
(spike volume date, yaxis(2)), ///
legend(span)
*-改进
twoway (rarea high low date) ///
(spike volume date, yaxis(2)), ///
legend(span) ///
yscale(range(500 1400) axis(1)) /// // new!
yscale(range(0 5) axis(2)) /// // new!
ylabel(,angle(0)) /// // new!
ylabel(,angle(0) axis(2))
*-4.5.5.直方图
help histogram
*（1）概览
sysuse nlsw88.dta, clear
histogram wage
gen ln_wage = ln(wage)
histogram ln_wage // 对数转换后往往更符合正态分布
*（2）图形的纵坐标
histogram wage // 长条的高度对应样本数占总样本的比例，总面积为1
graph save g0.gph, replace
histogram wage, fraction // 将长条的高度总和限制为 1
graph save g_frac.gph, replace
histogram wage, frequency // 纵坐标为对应的样本数，而非比例
graph save g_freq.gph, replace
graph combine g0.gph g_frac.gph g_freq.gph, rows(1)
*（3）其他选项
histogram ttl_exp, normal // 附加正态分布曲线
histogram wage, kdensity // 附加密度函数曲线
histogram wage, addlabels // 每个长条上方附加一个表示其高度的数字
histogram wage, by(race)
*（4）离散变量的直方图
histogram grade
graph save d1, replace
histogram grade, discrete // 离散变量的直方图必须附加 discrete 选项
graph save d2, replace
graph combine d1.gph d2.gph
*（5）长条的显示
histogram wage, gap(50)
histogram wage, gap(90) scheme(s1mono)
histogram wage, gap(99.9) scheme(s1mono) blwidth(thick)
*（6）分组绘制直方图
sysuse auto, clear
histogram mpg, percent discrete ///
by(foreign, col(1) note(分组指标：汽车产地) ///
title("图3：不同产地汽车里数") ///
subtitle("直方图") ///
) ///
ytitle(百分比) xtitle(汽车里数)
*操作实例->
sysuse sp500, clear
#delimit ;
histogram volume, freq normal
addlabels addlabopts(mlabcolor(blue))
xaxis(1 2)
ylabel(0(10)65, grid)
xlabel( 12321 "mean"
"-1 s.d."
14907 "+1 s.d."
"-2 s.d."
17493 "+2 s.d."
20078 "+3 s.d."
22664 "+4 s.d."
,axis(2) grid gmax
)
subtitle("图4：S&P 500 交易量 (2001年1月-12月)")
ytitle(频数)
xtitle("交易量(千笔)") xscale(titlegap(2))
xtitle("", axis(2))
note("数据来源：雅虎！财经数据");
#delimit cr
*-4.5.6.密度函数图
*（1）Kernal密度函数图
help kdensity
sysuse nlsw88, clear
kdensity wage
kdensity wage, normal
*（a）把多个变量的核密度函数图绘制在一张图上
sysuse sp500, clear
twoway (kdensity open) (kdensity low)
twoway (kdensity open) (kdensity high) (kdensity low) (kdensity close)
*（b）比较不同子样本的密度函数
sysuse auto, clear
kdensity weight, nograph generate(x dx)
kdensity weight if foreign==0, nograph generate(dx0) at(x)
kdensity weight if foreign==1, nograph generate(dx1) at(x)
label var dx "all cars"
label var dx0 "Domestic cars"
label var dx1 "Foreign cars"
line dx dx0 dx1 x, sort lw(*2.5 *1.5 *1.5)
*（c）另一种方法
sysuse auto, clear
kdensity weight, nograph gen(p_x d_x)
kdensity weight if foreign==0, nograph gen(p_x0 d_x0)
kdensity weight if foreign==1, nograph gen(p_x1 d_x1)
label var d_x "all cars"
label var d_x0 "Domestic cars"
label var d_x1 "Foreign cars"
twoway (line d_x p_x) (line d_x0 p_x0) (line d_x1 p_x1)
*（d）附加置信区间 -akdensity- 外部命令
sysuse auto, clear
akdensity length, stdbands(2)
*（2）双变量联合密度函数图 -kdens2- 外部命令
help kdens2
use grunfeld, clear
gen linv = log(invest)
gen lmkt = log(mvalue)
kdens2 linv lmkt
kdens2 linv lmkt, n(100) // defaults Min(_N,50)
kdens2 linv lmkt, xw(.5) yw(.5) // defaults `optimal'
*拓展阅读:Cox, N., 2005, Speaking Stata: Density probability plots, Stata Journal, 5(2): 259-273.
*-4.5.7.累积分布函数图
help cumul
*（1）基本概念
sysuse auto, clear
cumul price, gen(pcum)
line pcum price, sort
sort price
list price pcum in 1/5
dis 1/74
dis 3/74
list price pcum in 70/74
dis 72/74
dis 73/74
*（2）更为简洁的命令：displot （外部命令）
help distplot
sysuse auto, clear
distplot scatter mpg
distplot line mpg, by(foreign)
distplot connected mpg, trscale(ln(@))
*（3）支持的图形种类area bar connected dot dropline line scatter spike
foreach t in area bar connected dot dropline line scatter spike {
distplot `t' mpg, by(foreign)
}
*（4）cdfplot命令
help cdfplot
sysuse auto,replace
cdfplot length, normal
cdfplot length, by(foreign)
cdfplot length, by(foreign) norm saving(mygraph, replace)
*（5）示例：对数转换的作用
sysuse nlsw88, clear
cdfplot wage, normal
gen ln_wage = ln(wage)
cdfplot ln_wage, normal
*拓展阅读：Cox, N., 2004, Speaking stata: Graphing distributions, STATA JOURNAL, 4(1): 66-88. 
*Cox, N., 2004, Speaking Stata: Graphing categorical and compositional data, STATA JOURNAL, 4(1): 
190-215.
*-4.5.8.线性/非线性 拟合图
help twoway lfit
help twoway qfit
*（1）简单示例
sysuse auto, clear
scatter mpg weight || lfit mpg weight
scatter mpg weight || lfit mpg weight, by(foreign, total row(1))
*（2）附加置信区间
help twoway lfitci
help twoway qfitci
twoway (lfitci mpg wei, stdf) (scatter mpg wei) // 线性拟合的置信区间
twoway (scatter mpg wei) (lfitci mpg wei, stdf) // 图层的概念
twoway (qfitci mpg wei, stdf) (scatter mpg wei) // 非线性拟合
twoway (qfitci mpg wei, stdf level(99) color(yellow)) ///
(qfitci mpg wei, stdf level(90)) ///
(scatter mpg wei) // 置信水准
*-4.5.9.矩阵图：显示变量间的相关性
help graph matrix
sysuse auto, clear
graph matrix mpg weight length
pwcorr mpg weight length
graph matrix mpg weight length, ///
diag("mpg(汽车里数)" . "length (汽车长度)")
*（1）整体缩放
graph matrix mpg weight length, scale(1.5)
graph matrix mpg weight length, scale(0.8)
*（2）图标
sysuse citytemp, clear
sum
graph matrix heatdd-tempjuly
gr mat heatdd-tempjuly, msymbol(point)
help symbolstyle
*（3）半边显示
gr mat heatdd-tempjuly, ms(p) half
*（4）坐标刻度和标签
gr mat heatdd-tempjuly, ms(p) half ///
maxes(ylab(#4) xlab(#4))
*（5）附加网格线
gr mat heatdd-tempjuly, ms(p) half ///
maxes(ylab(#4, grid) xlab(#4, grid))
*-4.5.10.柱状图
*（1）一维柱状图
help graph bar
*命令1：graph bar yvars ... 
*命令2： graph bar (mean) varlist, over(g1) over(g2)... [other options]
*（a）基本用法: graph bar yvars ... 
sysuse nlsw88, clear
graph bar wage, over(race)
*（b）组变量的设定
sysuse nlsw88, clear
graph bar (mean) wage, over(race) scheme(s1mono)
graph bar (mean) wage, over(smsa) over(married) over(collgrad)
#delimit ;
graph bar (mean) wage, over(smsa) over(married) over(collgrad)
title("Average Hourly Wage, 1988, Women Aged 34-46")
subtitle("by College Graduation, Marital Status, and SMSA residence")
note("Source: 1988 data from NLS, U.S. Dept. of Labor, Bureau of Labor Statistics");
#delimit cr
*（c）柱体的样式
help barlook_options
graph bar (mean) wage hours, over(race) over(married) ///
scheme(s1mono) ///
bar(1, bstyle(p1)) ///
bar(2, bstyle(p6))
*（d）柱体的标签
help blabel_option
graph bar (mean) wage, over(race) over(married) ///
blabel(bar, position(outside) format(%3.1f) color(green))
graph hbar (mean) wage, over(industry) over(married) ///
blabel(bar, position(outside) format(%3.1f) ///
color(blue) size(vsmall))
*（e）累加柱体
sysuse educ99gdp, clear
graph hbar (mean) public private, over(country)
graph hbar (mean) public private, over(country) stack
*操作实例->
generate total = private + public
#delimit ;
graph hbar public private, stack
over(country, sort(total) descending)
blabel(bar, posi(center) color(white) format(%3.1f))
title( "Spending on tertiary education as % of GDP, 1999", span pos(11))
subtitle(" ")
note("Source: OECD, Education at a Glance 2002", span) ;
#delimit cr
*进一步美化
generate frac = private/(private + public)
#delimit ;
graph hbar public private, stack percent
over(country, sort(frac) descending)
blabel(bar, posi(center) color(white) format(%3.1f))
title("Public and private spending on tertiary education, 1999", span pos(11) )
subtitle(" ")
note("Source: OECD, Education at a Glance 2002", span);
#delimit cr
*（f）重叠柱体
sysuse nlsw88, clear
graph bar (mean) hours wage, over(race) over(married)
graph bar (mean) hours wage, over(race) over(married) bargap(-30)
*（g）图形的比例
sysuse nlsw88, clear
graph hbar wage, over(ind, sort(1)) over(collgrad)
graph hbar wage, over(ind, sort(1)) over(collgrad) ysize(4) xsize(8)
*（2）二维柱状图
help twoway bar
sysuse sp500, clear
twoway bar change date in 1/100
twoway bar change date in 1/100, barwidth(0.6)
sysuse pop2000, clear
replace maletotal = -maletotal
twoway bar maletotal agegrp, horizontal || bar femtotal agegrp, horizontal
*操作实例->
sysuse pop2000, clear
replace maletotal = -maletotal/1e+6
replace femtotal = femtotal/1e+6
gen zero = 0
#delimit ;
twoway (bar maletotal agegrp, horizontal xvarlab(Males))
(bar femtotal agegrp, horizontal xvarlab(Females))
(scatter agegrp zero, mlabel(agegrp) mlabcolor(black) msymbol(i))
, xtitle("Population in millions") ytitle("")
plotregion(style(none))
ysca(noline) ylabel(none)
xsca(noline titlegap(-3.5))
xlabel(-12 "12" -10 "10" -8 "8" -6 "6" -4 "4" 4(2)12,
tlength(0) grid gmin gmax)
legend(label(1 Males) label(2 Females))
legend(order(1 2))
title("US Male and Female Population by Age, 2000")
note("Source: U.S. Census Bureau, Census 2000");
#delimit cr
*解析：
scatter agegrp zero
scatter agegrp zero, mlabel(agegrp) mlabcolor(black) msymbol(i)
*-4.5.11.点图
help graph dot
*事实上是柱状图的另一种表示方法，比较适合中文投稿，省墨！
sysuse nlsw88, clear
graph dot wage, over(occ) by(collgrad)
graph dot wage, over(occ,sort(1)) by(collgrad)
*操作实例->
sysuse nlsw88, clear
#delimit ;
graph dot wage, over(occ, sort(1))
by(collgrad,
title("Average hourly wage, 1988, women aged 34-46", span)
subtitle(" ")
note("Source: 1988 data from NLS, U.S. Dept. of Labor, 
Bureau of Labor Statistics", span)
);
#delimit cr
*-4.5.12.函数图
help twoway function
twoway function y=normalden(x), range(-4 4) n(15)
twoway function y=normalden(x), range(-4 4) dropline(-1.96 1.96)
twoway function y=normalden(x), range(-4 4) xline(-1.96 1.96)
twoway function y=normalden(x), range(-4 4) dropline(-1.96 1.96) horizon
twoway function y=exp(-x/6)*sin(x), range(0 12.57) ///
xlabel(0 3.14 "pi" 6.28 "2 pi" 9.42 "3 pi" 12.57 "4 pi") ///
yline(0, lstyle(foreground)) dropline(1.48) ///
plotregion(style(none)) ///
xsca(noline) ytitle(" ") xtitle(" ")
sysuse sp500, clear
twoway (scatter open close, msize(*.35) mcolor(*.8)) ///
(function y=x, range(close) yvarlab("y=x") clwidth(*1.5))
*操作实例->
#delimit ;
twoway
function y=normden(x), range(-4 -1.96) color(gs12) recast(area)
|| function y=normden(x), range(1.96 4) color(gs12) recast(area)
|| function y=normden(x), range(-1.96 -1.64) color(green) recast(area)
|| function y=normden(x), range(1.64 1.96) color(green) recast(area)
|| function y=normden(x), range(-4 4) lstyle(foreground)
||,
plotregion(style(none))
legend(off)
xlabel(-4 "-4 sd" -3 "-3 sd" -2 "-2 sd" -1 "-1 sd" 0 "mean"
1 "1 sd" 2 "2 sd" 3 "3 sd" 4 "4 sd"
, grid gmin gmax)
xtitle("");
#delimit cr
*-4.5.13.合图示例：graph combine命令
*操作实例1->
sysuse lifeexp, clear
gen loggnp = log10(gnppc)
label var loggnp "人均GNP(Log10)"
label var lexp "期望寿命"
scatter lexp loggnp, ysca(alt titlegap(1.5)) ///
xsca(alt titlegap(0.8)) ///
xlabel(, grid gmax) ///
ylabel(,angle(0)) ///
saving(yx, replace)
histogram lexp, percent xsca(alt reverse titlegap(0.8)) ///
horiz xtitle(占比) ylabel(,angle(0)) ///
saving(hy, replace)
histogram loggnp, percent ysca(alt reverse titlegap(1.5)) ///
ytitle(占比) ylabel(,nogrid angle(0)) ///
xscale(titlegap(2)) xlabel(,grid gmax) ///
saving(hx, replace)
graph combine hy.gph yx.gph hx.gph, ///
hole(3) imargin(0 0 0 0) ///
graphregion(margin(l=12 r=12)) ///
title("图1：期望寿命与人均 GNP") ///
note("资料来源: 世界银行小组，1988")
*-进一步美化
sysuse lifeexp, clear
gen loggnp = log10(gnppc)
label var loggnp "人均GNP(Log10)"
label var lexp "期望寿命"
scatter lexp loggnp, ysca(alt titlegap(1.5)) ///
xsca(alt titlegap(0.8)) ///
xlabel(, grid gmax) ///
ylabel(,angle(0)) ///
saving(yx, replace)
histogram lexp, percent xsca(alt reverse titlegap(0.8)) ///
horiz xtitle(占比) ylabel(,angle(0)) ///
saving(hy, replace) ///
fxsize(25) // new! fy
histogram loggnp, percent ysca(alt reverse titlegap(1.5)) ///
ytitle(占比) ylabel(,nogrid angle(0)) ///
xscale(titlegap(2)) xlabel(,grid gmax) ///
saving(hx, replace) ///
fysize(25) // new! fx
graph combine hy.gph yx.gph hx.gph, ///
hole(3) imargin(0 0 0 0) ///
graphregion(margin(l=12 r=12)) ///
title("图1：期望寿命与人均 GNP" ) ///
subtitle(" ", size(*0.5)) /// new! a blank line
note("资料来源: 世界银行小组，1988")
*解释：
* fxsize(#) 仅将 x 轴方向缩小为原始尺寸的 25%
* fysize(#) 仅将 y 轴方向缩小为原始尺寸的 25%
*操作实例->
sysuse sp500, clear
replace volume = volume/1000
twoway rarea high low date, name(hilo, replace)
twoway spike volume date, name(vol, replace)
graph combine hilo vol
*美化 I
graph combine hilo vol, cols(1)
*美化 II
twoway rarea high low date, ///
xscale(off) name(hilo, replace) // new! off
graph combine hilo vol, cols(1)
graph combine hilo vol, cols(1) imargin(b=1 t=1)
*美化 III
twoway spike volume date, name(vol, replace) ///
ylabel(5 15 25) fysize(25) // new! fysize
graph combine hilo vol, cols(1) imargin(b=1 t=1)
*-4.5.14.三维图形 -surface- 外部命令
clear
set obs 900
gen x = int((_n - mod(_n-1,30) -1 ) /30 )
gen y = mod(_n-1,30)
gen z = normalden(x,10,3)*normalden(y,15,5)
surface x y z
*-4.5.15.地 图
*（1）tmap命令
*a查看最新资料
findit tmap
help tmap
*b说明文档和范例
view browse http://www.stata.com/support/faqs/graphics/tmap.html 
*c相关辅助命令
doedit usmaps.do // module to provide US state map coordinates for tmap
findit usmaps2 // module to provide US county map coordinates for tmap
*操作实例->
cd c:\soft&photo\teach\4经济统计分析软件应用\ppt-硕博\初级视频配套资料\Net_course_A\A3_graph
use Us-Database.dta, clear
tmap choropleth murder, id(id) map(Us-Coordinates.dta)
tmap cho murder if conterminous, id(id) map(Us-Coordinates.dta)
tmap cho murder if conterminous, id(id) ocolor(white) ///
map(Us-Coordinates.dta) palette(Blues)
tmap propsymbol murder if conterminous, ///
x(x_coord) y(y_coord) map(Us48-Coordinates.dta) ///
sshape(o) scolor(edkblue) fcolor(eltblue)
tmap deviation murder if conterminous, ///
x(x_coord) y(y_coord) map(Us48-Coordinates.dta) ///
sshape(s) scolor(sienna) fcolor(eggshell) ///
tmap label label if conterminous, ///
x(x) y(y) map(Us48-Coordinates.dta) ///
lc(white) ls(0.9) fc(emerald)
use MilanoPolice-Database.dta, clear
tmap dot, x(x) y(y) map(MilanoOutline-Coordinates.dta) ///
by(type) marker(both) sshape(s d) ///
legtitle("Police force", size(*0.7)) legbox
*（2）spmap命令
*使用说明：
view browse http://www.stata.com/support/faqs/graphics/spmap.html 
help spmap
*操作实例->
cd c:\soft&photo\teach\4经济统计分析软件应用\ppt-硕博\初级视频配套资料\Net_course_A\A3_graph
use "Italy-RegionsData.dta", clear
spmap relig1 using "Italy-RegionsCoordinates.dta", id(id) ///
clnumber(20) fc(Greens2) oc(white ..) osize(medthin ..) ///
title("Pct. Catholics without reservations", size(*0.8)) ///
subtitle("Italy, 1994-98" " ", size(*0.8)) ///
legstyle(3) legend(ring(1) position(3)) ///
plotregion(icolor(stone)) graphregion(icolor(stone))
use "Italy-RegionsData.dta", clear
spmap relig1 using "Italy-RegionsCoordinates.dta", id(id) ///
clmethod(stdev) clnumber(5) ///
title("Pct. Catholics without reservations",size(*0.8)) ///
subtitle("Italy, 1994-98" " ", size(*0.8)) area(pop98) ///
note(" " ///
"NOTE: Region size proportional to population", size(*0.75))
*（3）中国地图
*操作实例1->
findit china map
cd c:\soft&photo\teach\4经济统计分析软件应用\ppt-硕博\初级视频配套资料\Net_course_A\A3_graph
use china_label, clear
tab name
replace name = subinstr(name, "省", "", .)
replace name = subinstr(name, "市", "", .)
replace name = subinstr(name, "回族自治区", "", .)
replace name = subinstr(name, "壮族自治区", "", .)
replace name = subinstr(name, "特别行政区", "", .)
replace name = subinstr(name, "自治区", "", .)
replace name = subinstr(name, "维吾尔", "", .)
tab name
gen x = uniform()
format x %9.3g
spmap x using "china_map.dta", id(id) /// 
label(label(name) ///
xcoord(x_coord) ycoord(y_coord) size(*.9)) ///
plotregion(icolor(stone)) graphregion(icolor(stone)) ///
clnumber(8) fc(Greens2) oc(white ..) osize(medthin ..)
*操作实例2->
cd c:\data
clear all
sjlog using cngcode1, replace
use "example.dta"
sjlog close, replace

sjlog using cngcode2, replace
cngcode, baidukey(CH8eakl6UTlEb1OakeWYvofh) province(Prov) city(City) district(Dis) address(Address) long(lon1) lat(lat1)
list
sjlog close, replace
sjlog using cngcode3, replace
cngcode, baidukey(CH8eakl6UTlEb1OakeWYvofh) fulladdress(FullA) long(lon2) lat(lat2)
list
sjlog close, replace
sjlog using cngcode4, replace
cngcode, baidukey(CH8eakl6UTlEb1OakeWYvofh) province(Prov) city(City) district(Dis) address(Address) fulladdress(FullA) long(lon3) lat(lat3)
list
sjlog close, replace
sjlog using cngcode5, replace
cngcode, baidukey(CH8eakl6UTlEb1OakeWYvofh) province(Prov) city(City) district(Dis) address(Address) fulladdress(FullA) ffirst long(lon4) lat(lat4)
list
sjlog close, replace
sjlog using cngcode6, replace
keep lon4 lat4
cnaddress, baidukey(CH8eakl6UTlEb1OakeWYvofh) latitude(lat4) longitude(lon4)
list
sjlog close, replace
sjlog using cngcode7, replace
keep lon4 lat4
cnaddress, baidukey(CH8eakl6UTlEb1OakeWYvofh) latitude(lat4) longitude(lon4) coordtype(wgs84ll)
list
sjlog close, replace
*-其它命令
findit spgrid
doedit spgrid_example.do // 构建地图网格
*------------
*->4.6结语
*------------
*学会帮助画天下！
*一本有用的书：Mitchell, M. A visual guide to Stata graphics. Stata Press, 2008.
view browse "http://www.stata.com/support/faqs/graphics/gph/statagraphs.html"
*练习：一个尚未搞定的圆圈
twoway ( function y = sqrt(1-x^2), ///
plotregion(margin(0)) ///
range(-1.5 1.5) lc(blue) ) ///
( function y = -sqrt(1-x^2), ///
plotregion(margin(0)) ///
range(-1.5 1.5) lc(blue) ) ///
, ///
ysize(2) xsize(2) ///
ylabel(-1.5 1.5) xlabel(-1.5 1.5)
*-方案 1：
twoway ( function y = sqrt(1-(x-1)^2), ///
plotregion(margin(0)) ///
range(-0 2) lc(blue) ) ///
( function y =-sqrt(1-(x-1)^2), ///
plotregion(margin(0)) ///
range(0 2) lc(blue)) ///
, ///
ysize(3) xsize(3) ///
ylabel(-1.5 1.5) xlabel(-1 2)
*-方案 2：
clear
set obs 100000
gen z = invnorm(uniform())
gen y = sin(z)
gen x = cos(z)
twoway (scatter y x), ysize(4) xsize(4)
twoway (scatter y x, msymbol(smcircle)), ysize(4) xsize(4)
*================================over=======================================*