***replicates table A1, rows 1-3 and row 5 of each panel.  
***Row 4 is derived from data to figure 5, and is created at the end of fig-5.do.  Row 5 uses the output table from this program, and is: row 3 - row 4 / row 3 
***Change the date range below to generate panel A vs panel B
***unicon-collapse-byagesex uses collapsed unicon CPS data and is created by unicon-collapse-byagesex
***flows-annual-age-sex is created by match_flows-age-sex.do

set more off
clear
use "\\tsclient\G\research\brookings-dynamism\dta\pub\flows-annual-age-sex.dta", clear
rename n n_flows
merge year age using "\\tsclient\G\research\brookings-dynamism\dta\pub\unicon-collapse-byagesex.dta"
rename n n_unicon
rename n_flows n

preserve
keep if year>=1981
drop if age<=16
drop if age==.

sort age sex
collapse (mean) e u n n_unicon, by(age sex)
sort age sex
foreach var of varlist e u n n_unicon {
sum `var'
gen share_`var'=`var'/`r(sum)'
}
keep share_e-share_n_unicon age sex
sort age sex
tempfile share
save `share', replace

restore

drop if age<=16
drop if age==.


***change date range for panel A vs B
*gen yr=1 if year>=1991 & year<=1995
gen yr=1 if year>=1981 & year<=1985
replace yr=2 if year>=2010 & year<=2014


drop if yr==.

preserve

sort yr
replace en=en*e
replace eu=eu*e
replace ue=ue*u
replace un=un*u
replace ne=ne*n
replace nu=nu*n

collapse (sum) en eu ue un ne nu e u n, by(yr)
replace en=en/e
replace eu=eu/e
replace ue=ue/u
replace un=un/u
replace ne=ne/n
replace nu=nu/n

gen age=999
gen sex=3
sort age sex yr
tempfile temp
save `temp', replace
restore 
preserve
collapse (mean) empchange migstate [aw=n_unicon], by(yr)
gen age=999
gen sex=3
sort age sex yr
merge age sex yr using `temp'
assert _merge!=.
drop _merge

sort age sex yr
tempfile agg
save `agg', replace

restore
preserve
gen tmp=n
sort age sex yr
replace en=en*e
replace eu=eu*e
replace ue=ue*u
replace un=un*u
replace ne=ne*n
replace nu=nu*n

collapse (sum) en eu ue un ne nu e u n, by(age sex yr)
replace en=en/e
replace eu=eu/e
replace ue=ue/u
replace un=un/u
replace ne=ne/n
replace nu=nu/n
sort age sex yr

tempfile temp
save `temp', replace

restore
gen tmp=n_unicon
sort age sex yr
collapse (mean) empchange migstate (rawsum) n_unicon [aw=tmp], by(age sex yr)
sort age sex yr
merge age sex yr using `temp'
assert _merge!=.
drop _merge
append using `agg'

sort age sex
merge age sex using `share'
drop _merge

foreach var of varlist en eu {
sort age sex yr

by age sex: gen d_`var'=`var'-`var'[_n-1] if yr==2
sort yr age sex

sort age sex yr
gen d_cfct=d_`var'*share_e if yr==2

sort yr age sex
gen d_`var'_cfct=sum(d_cfct) if yr==2
drop d_cfct
}

foreach var of varlist ue un {
sort age sex yr

by age sex: gen d_`var'=`var'-`var'[_n-1] if yr==2
sort yr age sex

sort age sex yr
gen d_cfct=d_`var'*share_u if yr==2

sort yr age sex
gen d_`var'_cfct=sum(d_cfct) if yr==2
drop d_cfct
}

foreach var of varlist ne nu {
sort age sex yr

by age sex: gen d_`var'=`var'-`var'[_n-1] if yr==2
sort yr age sex

sort age sex yr
gen d_cfct=d_`var'*share_n if yr==2

sort yr age sex
gen d_`var'_cfct=sum(d_cfct) if yr==2
drop d_cfct
}

foreach var of varlist empchange migstate {
sort age sex yr

by age sex: gen d_`var'=`var'-`var'[_n-1] if yr==2
sort yr age sex


sort age sex yr
gen d_cfct=d_`var'*share_n_unicon if yr==2

sort yr age sex
gen d_`var'_cfct=sum(d_cfct) if yr==2
drop d_cfct

}

mat A=J(4,6,0)
local j=1
foreach var of varlist en eu ue ne empchange migstate {
sum `var' if yr==1 & age==999 & sex==3
mat A[1,`j']=`r(mean)'
sum `var' if yr==2 & age==999 & sex==3
mat A[2,`j']=`r(mean)'
sum d_`var' if yr==2 & age==999 & sex==3
mat A[3,`j']=`r(mean)'
sum d_`var'_cfct if yr==2 & age==999 & sex==3
mat A[4,`j']=`r(mean)'
local ++j
}

drop _all
svmat A
save "\\tsclient\G\research\brookings-dynamism\output\pub\table-A1.dta", replace
