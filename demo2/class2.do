* 第二讲 数据文件建立和管理
* Epidata 数据录入与合理性判断软件 Excel并不是一个很好的数据录入工具
* 2.1 数据录入：
*   edit window   you can change the name of a var
*   input (小样本)
input x y
1 2
3 4
end
* 数据读取
* use [var] [if] [in] using filename [,clear nolabel]
* nolabel 在读取数据时清除数据中的变量的值的标签
* clear 在读取新数据时清除程序已读数据
cd "C:\data"
use make mpg using auto.dta ,clear
* == != > < >= <= & |
use auto.dta if price>7000 ,clear
use auto.dta in 1/20 ,clear
* in #    第#个观测样本
* in f/#  第一个到第#个观测样本
* in #/l  第#个到最后一个观测样本
* use sysuse/webuse/netuse

* 数据导入
* import excel [using] filename [, import_excel_options]
cd "C:\data"
sysuse auto
export excel auto ,firstrow(variables)
import excel auto.xls ,firstrow clear
describe
import excel auto.xls ,cellrange(:D70) firstrow clear  //A1到D70的数据，注意，第一行是变量名，即1到69行A、B、C、D列的数据
describe
import excel make mpg using auto.xls ,clear
describe
import excel make=A mpg=B using auto.xls ,firstrow clear
describe

* 导入文本数据，交代分隔符
insheet using auto.txt ,tab
insheet using auto.txt ,comma clear   //comma 英文逗号
insheet mpg price using auto.txt ,delimiter("/")

infile v1 v2 v3 using auto.txt ,clear


* 2.2 数据保存
save auto1a ,replace
export excel auto ,firstrow(variables)


* 2.3 变量属性
* 名称 标签 值标签
* name 变量名
* label 标签：数据标签 变量标签 值标签
* describe 显示变量详情
rename old_var new_var   //改名
rename (old1 old2) (new1 new2)
rename t* t1*

label data "label"
label var varname "label"

* 值标签修改
label define r1_labelname 1 "1次" 2 "2次" 3 "3次"
label value r1 r1_labelname 
label dir //显示值标签名
label list //显示值标签内容

* 数据类型
* 整数：
*   byte 字节型 (-100,+100)
*   int 整型 (-32000,+32000)
*   long 长整型 (-2.14*10^10,+2.14*10^10)
* 小数：
*   float 浮点型 8位有效数字
*   double 双精度型 16位有效数字
* 字符串：
*   str# 字符串型
list price if make=="BMW 360i"
* recast 改变数据类型
recast float length
display gear_ratio
* float改int 直接取整数部分
* format 显示格式
* %8.0g 小数点后零位，小数点前八位   %6.2f 小数点后两位，小数点前六位
format price %6.1f
* 数值转字符串 字符串转数值
* encode（分类变量，字符串转数值）    destring（含数值数据，把字符串转数值）
* decode                            tostring
destring ,ignore("万 a")
* 新变量的生成
* 满意度调查 1-5 有时可以观察3以上或3以下 这时候需要根据其生成新的变量
gen mx2=1 if mx>=4 & mx!=. //stata会认为缺失值为最大
replace mx2=0 if mx2==.
//gen mx2=(mx>=4 & mx!=.)
//recode mx (1 2 3 = 0) (4 5 = 1) ,generate (mx2)
//平均数 mean
//中位数 median
//众数 med
bysort sex: egen mGPA=mean(GPA) 

* 缺失数据
//mvencode 用特定数值代表缺失  mvdecode 将特定数值处理为缺失值
* eg： 88888 income
mvdecode inc, mv(88888=. \ 44444=.)
* 变量或观测值的删除、保存与显示
//drop 删除变量
//keep 反向删除
//drop if medage>32

* 排序
//sort 只能从小到大排 同时对多个
//gsort +x1 -x2

* 数据集的合并与附加
//CHNS
