*** 练习1-1
input str20 course score
"管理学" 73
"农业经济学" 83
"计量经济学" 93
"农村经济统计" 83
end
cd "C:\data"
save myscore ,replace

*** 练习1-2
cd "C:\data"
use myscore ,clear
outsheet using myscore_txt.txt


*** 练习2
cd "C:\data"
log using "log.txt"  //在C盘data文件夹下形成log.txt日志记录
use auto ,replace
describe price headroom length weight  //显示变量具体信息
rename (price headroom length weight) (pri hroom leng weig)
mvencode rep78 if rep78==. ,mv(9999)  //缺失值修改
replace leng=230 if leng>233

recode leng (142/170 = 1) (171/204 = 2) (205/233 = 3) ,gen(lengtype)  //根据变量 leng 分类并生成新的变量 lengtype
label var lengtype "length type"  //将变量 lengtype 的标签（label）修改为 "length type"
label define length_type 1 "A级车" 2 "B级车" 3 "C级车" //定义值一类标签 length_type
label values lengtype length_type  //给变量 lengtype 赋予 值标签 length_type

decode lengtype ,gen(lengtype2)  //将变量 lengtype 按值标签内容转化成字符串型变量 lengtype2
gsort +pri -hroom
log close