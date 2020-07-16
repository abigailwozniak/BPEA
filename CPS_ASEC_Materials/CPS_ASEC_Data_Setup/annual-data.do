***creates annual-level dataset for time series analysis
***unicon-collapse has firm change rates, and is created from unicon CPS data by unicon-collapse
***trendest has migration rates and is created by ____________
***elsby-michaels-ratner is flows data from Elsby, Michaels, and Ratner
***bls-flows-yearly is annual flows data from the BLS


use "\\tsclient\G\research\brookings-dynamism\dta\data\unicon-collapse.dta", clear
keep indgroupchange occgroupchange empchange year
replace year=year-1
sort year
tempfile unicon
save `unicon', replace

use "\\tsclient\G\research\brookings-dynamism\dta\data\trendest.dta", clear
keep smigrant year
replace year=year-1
sort year
tempfile uniconmigrate
save `uniconmigrate', replace

use "\\tsclient\G\research\brookings-dynamism\dta\data\elsby-michaels-ratner.dta", clear
drop if year==1967 | year==2013
sort year
collapse (mean) eu ue nu un en ne, by(year)

merge year using `unicon'
drop _merge
sort year
merge year using "\\tsclient\G\research\brookings-dynamism\dta\data\trendest.dta", keep(jcr jdr exemss uirate)
drop _merge
sort year
merge year using `uniconmigrate'
drop _merge
sort year 
merge year using "\\tsclient\G\research\brookings-dynamism\dta\data\bls-flows-yearly.dta"
drop _merge
sort year
drop if year<=1947

replace eu=flowsEU_bls if flowsEU_bls!=.
replace ue=flowsUE_bls if flowsUE_bls!=.
replace nu=flowsIU_bls if flowsIU_bls!=.
replace un=flowsUI_bls if flowsUI_bls!=.
replace en=flowsEI_bls if flowsEI_bls!=.
replace ne=flowsIE_bls if flowsIE_bls!=.

drop flowsEE-flowsIE


save "\\tsclient\G\research\brookings-dynamism\dta\pub\data.dta", replace
