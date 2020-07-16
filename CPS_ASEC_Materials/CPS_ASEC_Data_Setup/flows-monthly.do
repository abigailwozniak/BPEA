***merges in flows data from Elsby, Michales, and Ratner with most recent data as provided by the BLS

use "\\tsclient\G\research\brookings-dynamism\dta\bls-flows.dta", clear
rename month m
sort year

replace m=3 if m==1 | m==2
replace m=6 if m==4 | m==5
replace m=9 if m==7 | m==8
replace m=12 if m==10 | m==11

replace ee=ee/e
replace eu=eu/e
replace en=en/e
replace nu=nu/n
replace un=un/u
replace ne=ne/n
replace ue=ue/u

sort year m
collapse (mean) eu ue nu un en ne, by(year m)

sort year m
keep if year>=2013
tempfile temp
save `temp', replace

use "\\tsclient\G\research\brookings-dynamism\dta\pub\elsby-michaels-ratner.dta"
drop if year==2013
append using `temp'
sort year m
save "\\tsclient\G\research\brookings-dynamism\dta\pub\flows-monthly.dta", replace

