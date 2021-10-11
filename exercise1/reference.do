*** 练习1
input str10 course score
"math" 60
"eng" 70
"sta" 80
"agr" 85
end
save "c:\data\myscore" ,replace
use "c:\data\myscore" ,clear
export delimited "c:\data\myscore_txt.txt" ,replace

*** 练习2
log using "c:\data\prac2.smcl"
sysuse auto ,clear
codebook price headroom length weight
ren (price headroom length weight) (pri hroom leng weig)
mvencode rep78 ,mv(.=9999)
replace leng=230 if leng>=233
recode leng (142/170 = 1 "A级车") (171/204 = 2 "B级车") (205/233 = 3 "C级车") ,generate(lengtype)
label var lengtype "length type"
decode lengtype ,generate(lengtype2)
gsort +pri -hroom
log close
exit ,clear