*Title: Group2.do

*Created by: Alessia Augello, Giorgia Fleischmann, Alessia Poli
*Created on: 3/12/2022
*Last modified on: [7/12/2022]

*Purpose: This Group2.do file answers the tasks for the STATA assignment, concerning the "Rule of law and female entrepreneurship" by Ashraf et al. (2019)
*******************************************************************************

*** Task 1: getting started with your data ***

use "pathname/panel_data_avg_ADG.dta"

browse
list CountryName 

*** Task 2: refreshing yuor memory on descriptive statistics ***

summarize wb_majFemOwned_mr Discriminationinthefamily_mr, detail 
* summary statistics 

*** Task 3: correlation matrices ***

correlate Discriminationinthefamily_avg Discriminationinthefamily_mr Discriminationinthefamily_ymr Discriminationinthefamily_frs Discriminationinthefamily_yfrs Restrictedphysintegrity_avg Restrictedphysintegrity_mr Restrictedphysintegrity_ymr Restrictedphysintegrity_frs Restrictedphysintegrity_yfrs

*** Task 4: bar graph ***

summarize wb_majFemOwned_mr, detail 
* to find the value of the median of wb_majFemOwned_mr

* Figure 1: Female owned firms across countries 
graph bar (asis) wb_majFemOwned_mr if wb_majFemOwned_mr != (.), over(CountryName, sort(wb_majFemOwned_mr) label(angle(forty_five) labsize(tiny))) ytitle(Female-owned businesses (%)) ytitle(, size(medium) margin(tiny)) ylabel(, angle(horizontal)) title(Female owned firms across countries) yline(.19507)

summarize rulelaw_mr, detail

* Figure 2: WB rule of law index across countries
graph bar (asis) rulelaw_mr, over(CountryName, sort(rulelaw_mr) label(angle(forty_five) labsize(tiny))) ytitle(WB index of law index (most recent)) ytitle(, size(medium) margin(tiny)) ylabel(, angle(horizontal)) title(WB rule of low index across countries) yline( -.4433655)

*** Task 5: scatter plots *** 

* Figure 3: Female business ownership and family discrimination (linear regression)
twoway (scatter wb_majFemOwned_mr Discriminationinthefamily_mr, mlabel(CountryName) mlabsize(tiny)) (lfit wb_majFemOwned_mr Discriminationinthefamily_mr), ytitle(Female-owned businesses (%)) ylabel(, angle(horizontal)) xtitle(Discrimination in the family) title(Female Business Ownership and Family Discrimination, size(medium)) legend(order(2 "fitted values" 1 "country name") size(small))

reg wb_majFemOwned_mr Discriminationinthefamily_mr 

* Figure 4: Female business ownership and family discrimination (quadratic regression)
twoway (scatter wb_majFemOwned_mr Discriminationinthefamily_mr, mlabel(CountryName) mlabsize(tiny)) (qfit wb_majFemOwned_mr Discriminationinthefamily_mr), ytitle(Female-owned businesses (%)) ylabel(, angle(horizontal)) xtitle(Discrimination in the family) title(Female Business Ownership and Family Discrimination, size(medium)) legend(order(2 "fitted values" 1 "country name") size(small))

gen Discriminationinthefamily_mr2 = Discriminationinthefamily_mr*Discriminationinthefamily_mr
reg wb_majFemOwned_mr Discriminationinthefamily_mr Discriminationinthefamily_mr2

* Figure 5: Female business ownership and WJP score (linear regression)
twoway (scatter wb_majFemOwned_mr wjp_index_new_mr, mlabel(CountryName) mlabsize(tiny)) (lfitci wb_majFemOwned_mr wjp_index_new_mr, fcolor(%50)), ytitle(Female-owned businesses (%)) ylabel(, angle(horizontal)) xtitle(Discrimination in the family) title(Female Business Ownership and WJP score, size(medium)) legend(order(2 "95% CI" 3 "Fitted values" 1 "Country name") size(small))

reg wb_majFemOwned_mr wjp_index_new_mr  

*** Task 6: multiple entries table ***

summarize rulelaw_mr Restrictedphysintegrity_mr, detail

* Making Restrictedphysintegrity_mr and rulelaw_avg categorical (reference: median)
recode Restrictedphysintegrity_mr (min/20.8 = 0) (20.81/max = 1), generate (Restr_cat)
recode rulelaw_mr (min/-.3805971 = 0) (-.3805972/max = 1), generate (Rule_mr_cat)

label define MedianHighLow 0 "Low" 1 "High"
label values Restr_cat MedianHighLow
label values Rule_mr_cat MedianHighLow

label variable Rule_mr_cat "Rule of Law"
label variable Restr_cat "Restricted phyisical integrity"

* Number of countries by rule of law and restricted physical integrity
table Rule_mr_cat Restr_cat, statistic(frequency) statistic(percent)

*** Task 7: Creating a percentile variable ***

summarize majFemOwned_manuf_mr
sort majFemOwned_manuf_mr

* command xtile is built in STATA or calculating the quantile ranks of a variable 
xtile percentile = majFemOwned_manuf_mr, nq(8) 
tabstat majFemOwned_manuf_mr, stat(n mean min max) by(percentile)

list CountryName percentile majFemOwned_manuf_mr if majFemOwned_manuf_mr != (.)

*** Task 8: Regression analysis *** 

* making Discriminationinthefamily_mr categorical (rederence: median) 
summarize Discriminationinthefamily_mr, detail
recode Discriminationinthefamily_mr (min/40.05 = 1) (40.051/max = 0), generate (Discr_mr_cat)

* making rulelaw_mr categorical (reference: median)
sort rulelaw_mr
egen rulelaw_n = rank(rulelaw_mr)
gen rulelaw_perc = rulelaw_n /139*100
recode rulelaw_perc (min/50 = 0) (50.01/100 = 1), generate (rulelaw_cat1)

label variable Discr_mr_cat "Discr in family < med"
label variable rulelaw_cat1 "Rule of Law > med"

* regress rule of law, discrimination in the family and GDP pp 2011 on female entrepreneurship 
reg wb_majFemOwned_mr rulelaw_cat1##Discr_mr_cat wdi_ln_gdp_2011

* making wvs_manBeatWife_mr categorical (reference: median) 
summarize wvs_manBeatWife_mr, detail
recode wvs_manBeatWife_mr (min/.2721951 = 1) (.27219511/max = 0), generate (manBeatWife_mr_cat)
label variable manBeatWife_mr_cat "Violence on Wives < med" 

* regress rule of law and violence on wife on female entrepreneurship 
reg wb_majFemOwned_mr rulelaw_cat1##manBeatWife_mr_cat

* regress rule of law, violence on wife and GDP pp 2011 on female entrepreneurship 
reg wb_majFemOwned_mr rulelaw_cat1##manBeatWife_mr_cat wdi_ln_gdp_2011




