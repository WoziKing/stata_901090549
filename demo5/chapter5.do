*==================================
*第7讲 普通最小二乘法（初级篇+高级篇）
*==================================

*-------------------------------------
*->7.1简介：图解最小二乘法
*-------------------------------------


*-7.1.1.OLS估计原理
*H1: 二者之间存在线性关系（解释变量X是非随机的，被解释变量y是随机的）
* y = a0 + a1*x1 + a2*x2 + ... + ak*xk + u
* y = Xb + u 
*H2: X 是满秩的，i.e. rank(X) = k
*H3: 干扰项的条件期望为零（模型的设定是正确的）
* E[Xu] = 0 or E[u|X] = 0 
*OLS估计式的推导仅需要上述三个假设即可：
* E[X'(y - Xb)] = 0
* X'y - X'Xb = 0
* ==> X'Xb = X'y
* ==> b = inv(X'X)*X'y /*回归系数*/
*E[b] = E[inv(X'X)X'*(Xb0+u)] 
* = b0 + inv(X'X)X'E[u] 
* = b0 /*OLS 估计量是真实值的无偏估计*/
*y_hat = X*b /* 被解释变量的拟合值*/
*e = y - y_hat = y - Xb /* 残差*/
*操作案例->
do B1_ols_gr1a.do
*Stata估计命令
use B1_consume, clear
regress consume income //常数项是stata自动加入的
reg consume income if income>300
reg consume income in 5/11
regress consume income
predict y, xb
predict e, residual
list
*--------------估计结果的解释--------------------
*估计式的矩阵解析
local N = _N
gen cons = 1
mkmat consume, mat(y)
mkmat income cons, mat(X)
mat b = inv(X'*X)*X'*y
mat list b
mat list y
mat list X
*常数项的作用和含义（也是一个解释变量，条件期望）
use B1_consume, clear
regress consume income
egen avg_c = mean(consume)
egen avg_i = mean(income)
gen d_c = consume - avg_c
gen d_i = income - avg_i
regress d_c d_i, nocons
reg consum income
*----------------------------
*统计推断：回归系数的显著性
*b是一个随机数 b = inv(X'X)X'y, 因为y是随机的
do B1_ols_gr3.do
do B1_ols_gr2.do //实证样本与母体的关系
* H4: Var[ui|X] = sigma^2 //同方差假设
*结合 H3 可知， ui -- (0, sigma^2)
*Var[b] = inv(X'X)sigma^2 /* Var(Ax) = AVar(x)A'*/ 
*Var[b] = inv(X'X)X'*sigma^2*X*inv(X'X) = inv(X'X)sigma^2
*假设 ui -- i.i.d N(0, sigma^2) /*干扰项服从正态分布*/
* b -- N(b0, Var(b)) /*因为 b 是 y 的线性组合*/
* (bj - bj0)/s.e.(bj) -- t(n-k) /*t统计量*/
chapter5-do - Printed on 2021/10/26 13:00:36
Page 2
* H0: bj0 = 0 
* bj/s.e.(bj) --- t(n-k)
*sigma^2 的估计值 --- s^2 
local N = _N
local K = colsof(X)
mat e = y - X*b /*残差*/
mat s2 = (1/(`N'-`K'))*(e'*e)
*系数的标准误 --- s.e.(bj)
mat Var_b = s2*inv(X'*X)
mat list Var_b
dis sqrt(0.06187781)
dis sqrt(6535.7483)
*矩阵解析
mat se_b = cholesky(diag(vecdiag(Var_b)))
mat list se_b
reg consume income
*t值的计算：t = 系数/标准误
use B1_consume, clear
regress consume income
dis %4.2f 0.6848014/0.2487525 /*income 的 t 值*/
dis %4.2f 51.89511/80.84397 /*常数项 的 t 值*/
*矩阵解析
mat b0 = diag(b)
mat list b0
mat inv_se_b = inv(se_b)
mat list inv_se_b
mat t = hadamard(b0, inv_se_b)
mat list t
mat t = vecdiag(t)
reg consume income
*p值
*H0: bj = 0 即，系数估计值是否显著不等于零
*由于t值服从 t 分布，所以我们很容易计算其 p 值
help density functions
mat list t
local p_income = ttail(11-2, 2.75)*2 /*双尾*/
local p_cons = ttail(11-2, 0.64)*2
mat pvalue = (`p_income' \ `p_cons')
mat list pvalue
*置信区间
* (bj - bj0)/s.e.(bj) -- t(n-k) 
mat se_b = vecdiag(se_b)'
local t_c = invttail(11-2, 0.025)
mat CI95_low = b - `t_c'*se_b
mat CI95_high = b + `t_c'*se_b
mat list CI95_low
mat list CI95_high
reg consume income
*结果汇总
mat Result = (b, se_b, t', pvalue, CI95_low, CI95_high)
mat colnames Result = b se t p-value CI95_low CI95_high
mat list Result
reg consume income
*检验系数显著性的新方法：自体抽样法（Bootstrap）
bootstrap: reg consume income
bootstrap, reps(300): reg consume income
sysuse auto, clear
bootstrap, reps(300): reg price weight mpg foreign turn,noheader
reg price weight mpg foreign turn
*基本思想：
* 假设样本是母体中随机抽取的；
* 通过反复从样本中抽取样本来模拟母体的分布；
* 1. 从样本中可重复地抽取N个样本，执行OLS，记录系数估计值；
* 2. 将第一步重复进行300次，得到系数估计值的300个记录；
* 3. 统计这300个估计值的标准误 se_bs，将其视为实际估计值的标准误；
* 4. 计算 t 值和相应的 p 值
use B1_consume, clear
scatter consume income
chapter5-do - Printed on 2021/10/26 13:00:36
Page 3
*计算残差和拟合值
sysuse auto, clear
reg price weight length foreign
predict y_hat
predict e, res
reg price weight length if foreign==1
eret list
predict y_hat1 if e(sample)
predict e1 if e(sample), res
*-7.1.2.方差分析
*Total sum of square = Model sum of square + Residual sum of square
* y 的总变动 = 模型能够解释的变动 + 残差的变动
sysuse auto, clear
reg price weight length
predict yhat /*price的拟合值*/
predict e, res /*残差*/
foreach v of varlist price weight length{
egen avg_`v' = mean(`v')
gen dif_`v' = `v' - avg_`v'
}
qui reg dif_price dif_wei dif_len, nocons
predict yhatd
* TSS = MSS + RSS
* TSS = sum of yd^2 yd = y - mean(y) y的离差
gen dprice2 = dif_price^2
qui sum dprice2
dis "TSS = " %12.0f r(sum)
scalar TSS = r(sum)
* MSS = sum of yhatd^2 yhatd = Xd'b y拟合值的离差
gen yhatd2 = yhatd^2
qui sum yhatd2
dis "MSS = " %12.0f r(sum)
scalar MSS = r(sum)
* RSS = sum of e^2 e = y-yhat = y-X'b = yd - Xd'b 残差的离差
gen e2 = e^2
qui sum e2
dis "RSS = " %12.0f r(sum)
scalar RSS = r(sum)
reg price weight length
* MMS = MSS / (k-1) MS: mean of square
dis "MMS = " %12.0f MSS/2
* RMS = RSS / (N-k)
dis "RMS =" RSS/71
* TMS = TSS / (N-1)
dis "TMS =" TSS/73
reg price weight length
* Root MSE(mean square error): sqrt(s2) //均方根误或残差平方和均值的平方根
qui sum e2
scalar Root_MSE = sqrt(r(sum)/(74-3))
dis "Root MSE = " Root_MSE
* R^2 与 adj-R^2
* R^2 的基本定义
scalar R2a = MSS / TSS /*模型能够解释的波动占总波动的比例*/
dis R2a
scalar R2b = 1 - RSS/TSS
dis R2b
*对 R^2 的第二种理解
reg price weight length
* predict price_hat
corr price price_hat
local R2 = r(rho)^2 //rho截面效应（个体效应）在整个误差项中的百分比
dis R2 = 'R2'
*调整后的 R2
local adj_R2 = `R2' - (3-1)/(74-3)*(1-`R2')
dis "adj-R2 = " `adj_R2'
*-7.1.3.标准化系数（消除量纲，反映出自变量每变动1个标准差后，因变量的变动量）
sysuse auto, clear
reg price w l, beta
chapter5-do - Printed on 2021/10/26 13:00:36
Page 4
*处理过程的解析
foreach v of varlist price weight length{
egen `v'_s = std(`v') /* (v-m_v)/sd_v */
}
sum price_s weight_s length_s
reg price_s weight_s length_s, noheader
*评论：
*1.标准化系数的含义；
*2.我们可以按照这一方法估计出任何模型的标准化系数
*-7.1.4.边际效应
help mfx
regress price length weight
mfx, dydx /* dy/dx */
mfx, eyex /* d(lny)/d(lnx) */
mfx, dyex /* d(y)/d(lnx) */
sum weight length, detail
mfx, at(weight=3190, length=192.5)
mat A = (3190, 192.5)
mfx, at(A)
mfx replay, level(90)
*-7.1.5.假设检验
*单变量检验
use B1_production.dta,clear
reg lnY lnL lnK
test lnL = 0
test lnL = 0.7
* 线性约束检验
reg lnY lnL lnK
lincom lnL + lnK
lincom lnL + lnK - 1
* 包含线性约束的估计
constraint define 1 lnL+lnK = 1
cnsreg lnY lnL lnK, constraints(1)
preserve
sysuse auto,clear
constraint def 1 price = weight
constraint def 2 displ = weight
constraint def 3 gear_ratio = -foreign
cnsreg mpg price weight displ gear_ratio foreign length, c(1-3)
restore
* 联合检验
reg lnY lnL lnK
test lnL lnK
test (lnL=0.8) (lnK=0.2)
* 模型的整体拟合程度
* F 检验：检验除常数项外其他所有解释变量的联合解释能力是否显著
* X= [X1 X2] X1=常数 | X2=lnL lnK
test lnL lnK
reg lnY lnL lnK
* 非线性约束检验
testnl _b[lnL] * _b[lnK] = 0.25
testnl _b[lnL] * _b[lnK] = 0.5

cd C:\soft&photo\teach\4经济统计分析软件应用\ppt-硕博\初级视频配套资料\Net_course_A\A7_ols
*-------------------------------
*->7.2模型的设定和筛选
*-------------------------------
*-7.2.1.残差分析
* acprplot augmented component-plus-residual plot
* avplot added-variable plot
* avplots all added-variable plots in a single image
* cprplot component-plus-residual plot
* lvr2plot leverage-versus-squared-residual plot
* rvfplot residual-versus-fitted plot
* rvpplot residual-versus-predictor plot
*残差的正态性
sysuse auto, clear
reg price weight mpg turn foreign
chapter5-do - Printed on 2021/10/26 13:00:36
Page 5
predict e, res
kdensity e, normal
pnorm e /*P-P，对中间部位敏感*/
qnorm e /*e的分位值与正态分布的分位值关系图，对尾部敏感*/
sktest e
swilk e
*残差-拟合值图 rvfplot
rvfplot, yline(0)
*对特殊样本点的检验和处理
do B1_ols_lev.do
*几个基本概念：
* 离群样本点：残差值较大的样本点
* 杠杆样本点：与样本整体(X'X)很不相同的少数样本点
* 关键样本点：对回归结果有重要影响的少数样本点
*杠杆统计量：hj = x_j*inv(X'X)*x_j'
reg y x
predict lev, leverage
lvr2plot //杠杆-残差平方图
drop if x==30
reg y x
predict lev2, lev
list
lvr2plot
sysuse auto, clear
reg price weight mpg turn foreign
lvr2plot
lvr2plot, mlabel(make) mlabsize(vsmall)
*更直接的分析
predict lev, leverage
predict e, res
gen e2 = e^2
gsort -lev
list make price weight mpg foreign lev e2 in 1/10
gsort -e2
list make price weight mpg foreign lev e2 in 1/10
*杠杆样本点不必然是离群值，反之亦然
*关键样本点：对回归结果有重要影响的少数观察值，通常既是杠杆样本点，又是离群值
*DFITS统计量 DFITSj = rj*sqrt[hj/(1-hj)]
* rj = ej/[s(j)*sqrt(1-hj)] 标准化残差
predict dfits, dfits
dis 2*sqrt(5/74) /*经验临界值： 2*sqrt(k/N)*/
list make price weight mpg foreign dfits if abs(dfits)>0.51987524
sum price weight
preserve
reg price weight mpg turn foreign
drop if abs(dfits)>0.51987524
reg price weight mpg turn foreign
restore
*DFBETA统计量
qui reg price weight mpg turn foreign
dfbeta weight
dis 2/sqrt(e(N))
list make price weight mpg foreign DFweight if abs(DFweight)>2/sqrt(e(N))
sum price weight
*处理方法：删除？ Tobit模型
*-7.2.2.部分回归图 avplot/avplots
reg price weight mpg turn foreign
avplot weight
avplot weight,mlabel(make) xscale(r(-500 1400)) /* 标出样本标签 */
*---------------------解释-----------------------------
*纵轴：price 对除weight以外的所有变量回归得到的残差
*横轴：weight 对所有其他解释变量回归得到的残差
qui reg price mpg turn foreign
predict e_y , res
qui reg weight mpg turn foreign
predict e_x , res
reg e_y e_x
twoway (scatter e_y e_x) (lfit e_y e_x)
chapter5-do - Printed on 2021/10/26 13:00:36
Page 6
twoway (scatter e_y e_x, mlabel(make)) (lfit e_y e_x), xscale(r(1400))
*绘制所有变量的部分回归图
reg price weight mpg turn foreign
avplots
*-7.2.3.虚拟变量
*变截距
do B1_ols_dummy1.do
reg price weight
reg price weight if foreign==0
reg price weight if foreign==1
gen dum = 0
replace dum = 1 if foreign==1
reg price dum weight
*model: price = a0 + a1*dum + b*weight + u 
*price = a0 + b*weight + u /*dum=0 国产车*/
*price = (a0+a1) + b*weight + u /*dum=1 进口车*/
*斜率和截距同时变
do B1_ols_dummy2.do
gen dum = foreign==1
gen dum_weight = dum*weight
reg price dum weight dum_weight
*model：price = a0 + a1*dum + b0*weight + b1*dum_weight + u
*price = a0 + b0*weight + u /*dum=0 国产车*/
*price = (a0+a1) + (b0+b1)*weight + u /*dum=1 进口车*/
reg price weight
*交乘项
*y = b0+ b1*x1 + b2*x2 + b3(x2*x3)
*dy/dx2 = b2 + b3*x3 i.e., x2 的边际效果依赖于 x3
sysuse auto, clear
gen weiXlen = weight*length
reg price weight mpg foreign weiXlen
*汽车越长，重量对价格的边际影响就越小
*-7.2.4.结构突变检验：Chow test （邹至庄检验）
*基本思想
*y = a1 + b1*x1 + c1*x2 + u for group == 1
*y = a2 + b2*x1 + c2*x2 + u for group == 2
*y = a + b*x1 + c*x2 + u for both groups
*H0: a1=a2 ; b1=b2 ; c1=c2
do B1_ols_chow1.do /*图示*/
*检验方法
gen foreign_wei = foreign*weight
gen foreign_len = foreign*length
reg price wei len foreign foreign_wei foreign_len
*模型的含义
* price = c1 + a1*wei + b1*len + c2*foreign + a2*foreign_wei + b2*foreign_len
* price = c1 + a1*wei + b1*len /*foreign==0*/ 
* price = (c1+c2) + (a1+a2)*wei + (b1+b2)*len /*foreign==1*/ 
test foreign foreign_wei foreign_len /* c2=0; a2=0; b2=0 */
*另一种检验方法
test foreign
test foreign_wei, accum
test foreign_len, accum
*chow命令 findit chow
*-7.2.5.逐步回归法
sysuse auto, clear
*逐个剔除(Backward selection)
stepwise, pr(0.2): reg price mpg weight displ
stepwise, pr(0.2): reg price mpg weight displ foreign
stepwise, pr(0.05): reg price mpg weight displ foreign
*逐个分层剔除(Backward hierarchical selection)
stepwise, pr(0.2) hier: reg price mpg weight displ
stepwise, pr(0.2) hier: reg price mpg (weight displ)
qui reg price mpg weight displ
test weight displ
*逐个加入(Forward selection)
stepwise, pe(.2): reg price mpg weight displ
stepwise, pe(.2): reg price mpg weight displ foreign
*逐个分层加入(Forward hierarchical selection)
chapter5-do - Printed on 2021/10/26 13:00:36
Page 7
stepwise, pe(.2) hier: reg price mpg weight displ
stepwise, pe(.2) hier: reg price mpg weight displ foreign
*-7.2.6.多重共线性
*H2: X 是满秩的，i.e. rank(X) = k ==> X'X 是满秩的
*完全共线性
sysuse auto, clear
gen domestic = 1 - foreign
reg price wei len foreign domestic
*严重多重共线性：检验方法
* VIF 膨胀因子 VIF_j = 1/(1-R2_j)
reg price weight length headroom trunk turn gear_ratio
estat vif
qui reg length weight headroom trunk turn gear_ratio
dis 1/(1-e(r2))
qui reg weight length headroom trunk turn gear_ratio
dis 1/(1-e(r2))
*经验准则：(1) VIF 的均值 > 1
* (2) VIF 的最大值 >10 
pwcorr weight length, star(0.01)
pwcorr weight length headroom trunk turn gear_ratio, star(0.01)
gen wlr = weight/length /*汽车长度和重量高度相关*/
reg price wlr headroom trunk turn gear_ratio
estat vif
pwcorr wlr headroom trunk turn gear_ratio, star(0.01)
*CN(X'X) >20 共线性问题比较严重
coldiag2 weight length headroom trunk turn gear_ratio
collin weight length headroom trunk turn gear_ratio
*其他命令：perturb ranktest
*图形方式：
graph matrix price weight length headroom trunk turn gear_ratio,half

*----------------------------------------------
*->7.3共线性的征兆：一个模拟分析
*---------------------------------------------
*(1)虽然模型的R2非常高，但多数解释变量都不显著，甚至系数符号都不对
*(2)观察值的微小变动都会导致估计结果的大幅变动
*生成数据
clear
set obs 100
set seed 23459
gen n = _n
gen e = invnorm(uniform()) /*干扰项：标准正态分布*/
gen d = 0.01*invnorm(uniform())
gen x1 = 3*invnorm(uniform())
gen x2 = x1 + d
gen y = 10 + x1 + 5*x2 + e
*检验征兆1：严重共线性
reg y x1 x2
reg y x1 /*y = 10 + x1 + 5*x2 + e 
= 10 + 6*x1 + 5*d + e */
reg y x2 /*y = 10 + 6*x2 – d + e */
pwcorr y x1 x2 , star(0.01)
*对于不存在共线性问题的变量，其估计系数不受影响
gen z = 2*invnorm(uniform())
gen yz = 10 + x1 + 5*x2 + 0.6*z + e
reg yz x1 x2 z
reg yz x1 z
reg yz x2 z
*检验征兆2：观察值的微小变动
list in 1/5
reg y x1 x2
replace x2 = 10 in 1/1
reg y x1 x2
pwcorr y x1 x2 , star(0.01)
*-7.3.1.嵌套(nested)模型与非嵌套(nonnested)模型
*嵌套模型
sysuse auto, clear
reg price weight length foreign
chapter5-do - Printed on 2021/10/26 13:00:36
Page 8
reg price weight length foreign gear_ratio rep78 turn
test (gear_ratio=0) (rep78=0) (turn=0)
sysuse nlsw88, clear
reg wage age race married ttl_exp
reg wage age race married ttl_exp industry occupation collgrad
test industry occupation collgrad
*非嵌套模型
*特征：
* H0: y = Xb + u1
* H1: y = Zg + u2
* X 和 Z 中有一些公共的解释变量，但也有各自独特的解释变量
* 我们无法通过比较两个模型的 R2 来区分二者的优劣。
*= 检验：应用 nnest 命令
sysuse auto, clear
reg price weight foreign length headroom /*H0*/
reg price weight foreign turn /*H1*/
local X "weight foreign length headroom"
local Z "weight foreign turn"
nnest price `X' (`Z')
*= 检验：手动计算
*检验 H0
qui reg price `Z'
*qui predict yZ_hat 
reg price `X' yZ_hat
*检验 H1 
local X "weight foreign length headroom"
qui reg price `X'
qui predict yX_hat
local Z "weight foreign turn"
reg price `Z' yX_hat
*=一个问题：相互拒绝
sysuse nlsw88, clear
drop if grade==.|industry==.|occupation==.
local X "age race married grade collgrad"
local Z "age race married industry occupation ttl_exp"
sum wage `X' `Z'
nnest wage `X' (`Z') /*意味着包含所有变量的模型可能更好一些*/
reg wage `X' `Z'
*-7.3.2.模型的形式：是否遗漏了重要的变量？
*= link 检验
*如果模型的设定是正确的，那么y的拟合值的平方项将不应具有解释能力
sysuse auto, clear
regress mpg weight displ foreign
linktest
*或许是遗漏了重要的解释变量
gen wei2 = weight^2
reg mpg weight wei2 displ foreign
linktest
*或许被解释变量的设定也有问题
gen gpm = 1/mpg /*每公里耗油数*/
reg gpm weight displ foreign
linktest
*= Ramsey 检验
*基本思想：如果模型设定无误，那么拟合值和解释变量的高阶项都不应再有解释能力
regress mpg weight displ foreign
estat ovtest
estat ovtest, rhs
reg mpg weight wei2 displ foreign
estat ovtest

*---------------------------
*->7.4实证结果的呈现
*---------------------------
*-7.4.1.变量的基本统计量
sysuse auto, clear
sum price weight length gear turn
tabstat price weight length gear turn , ///
stat(mean sd p5 p25 med p75 p95 min max) ///
chapter5-do - Printed on 2021/10/26 13:00:36
Page 9
format(%6.2f) c(s)
*-7.4.2.变量的相关矩阵
*相关命令：pwcorr, pwcorr_a, pwcorrs, matpwcorr, pwcorrw
use educ3, clear
pwcorr crimes empgovt osigind popcol perhspls
pwcorr crimes empgovt osigind popcol perhspls, sig
pwcorr crimes empgovt osigind popcol perhspls, star(.01)
pwcorr crimes empgovt osigind popcol perhspls, star(.05)
help pwcorr_a
pwcorr_a crimes empgovt osigind popcol perhspls, star1(0.01) star5(0.05) star10(0.1)
*-7.4.3.引用Stata的返回值
sysuse auto, clear
reg price weight length turn
eret list
*-7.4.4.回归结果的呈现
help estimates
*estimate store / est table
sysuse nlsw88, clear
reg wage age race married grade
est store m_1
reg wage age race married grade collgrad smsa industry
est store m_2
reg wage age race married grade collgrad smsa industry occupation ttl_exp tenure
est store m_3
*方法1：est table 命令
est table m_1 m_2 m_3
est table m_1 m_2 m_3, stat(r2 r2_a N F) b(%6.3f) star
est table m_1 m_2 m_3, stat(r2 r2_a N F) b(%6.3f) star(0.1 0.05 0.01)
est table m_1 m_2 m_3, stat(r2 r2_a N F) b(%6.3f) se(%6.2f) star(0.1 0.05 0.01)
est table m_1 m_2 m_3, stat(r2 r2_a N F) b(%6.3f) se(%6.2f)
est table m_1 m_2 m_3, stat(r2 r2_a N F) b(%6.3f) t(%6.2f)
*处理成Word表格
*方法2：esttab 命令，需要下载：findit esttab
esttab m_1 m_2 m_3
esttab m_1 m_2 m_3, scalar(r2 r2_a N F) star(* 0.1 ** 0.05 *** 0.01) compress
esttab m_1 m_2 m_3, scalar(r2 r2_a N F) compress ///
star(* 0.1 ** 0.05 *** 0.01) ///
b(%6.3f) t(%6.3f) ///
mtitles(模型(1) 模型(2) 模型(3))