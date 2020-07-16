set more off

log using socialcapital.log, replace

/*** Read in public GSS data. Plot time series of social capital measures. Plus also jobfind measures. ***/

clear matrix
clear mata
set maxvar 32000
use GSS7214_R4.dta

* Drop black oversample in 1982 and 1987
drop if (sample==4 | sample==5) & year==1982
drop if sample==7 & year==1987
*tab1 sample if year==1982
*tab1 sample if year==1987

keep year id wtssall age sex trust memnum jobfind jobfind1

	*** trusty was alternate wording version asked in 1983 only. trust also asked in parallel that year.
	*** memnum available for 74,75,77,78,80,83,84,86-91,93,94,2004.
	*** Glaeser and Sacerdote argue that trust might be a good measure of aggregate social capital but not a good measure of indiv social capital
	*** For that, they argue memnum more appropriate

foreach x in trust memnum jobfind jobfind1 {
   replace `x'=. if `x'==.i
   }

/** Confused about why the dummies are ending up with more obs than the underlying variables... **/
/** Seem to be some entries counting as obs (e.g. in year and id) but with no data in them, no idea why **/

tab1 trust
gen trustd=(trust==1)
replace trustd=. if trust==. | trust==8 | trust==9 | trust==0

gen easyd=(jobfind==1) if jobfind~=.
gen hardd=(jobfind==3) if jobfind~=.
gen easyd1=(jobfind1==1) if jobfind1~=.
gen hardd1=(jobfind1==3) if jobfind1~=.

tab1 year if trust==. & trustd~=.
tab1 year if jobfind==. & easyd~=.
summ year id sex if age==.

summ 
tab1 jobfind jobfind1 trust
*bysort year: summ job*

preserve

*** Annual means, weighted using GSS weights
collapse (mean) trustd memnum easyd hardd easyd1 hardd1 [w=wtssall], by(year)
sort year
list

saveold gss_agg_trends.dta, version(13) replace

graph twoway scatter trustd year, title("Share saying most people can be trusted") ytitle("") xtitle("GSS Survey Year")
graph save trustd.gph, replace
graph twoway scatter memnum year, title("Average number of membership categories") ytitle("") xtitle("GSS Survey Year")
graph save memnum.gph, replace

graph twoway scatter easyd easyd1 year, title("Share saying finding an equivalent new job would be easy") ytitle("") xtitle("GSS Survey Year")
graph save easy.gph, replace
graph twoway scatter hardd hardd1 year, title("Share saying finding an equivalent new job would be very hard") ytitle("") xtitle("GSS Survey Year")
graph save hard.gph, replace

export excel trustd year using trustd_year.xlsx, firstrow(var) replace

/*** Merge in state identifiers from restricted-use GSS ***/
/*** Create state-year level means of trust, memnum and jobfind dummies ***/

restore
sort year id

merge 1:1 year id using "E:\GSS7214geo_cross.DTA"
summ year if _merge < 3
/*
* Only failed merges were black oversamples from 1982, 1987 and for 2012, 2014 which is not on current sensitive data CD
tab1 year if _merge==1
tab1 year if _merge==2
tab1 year if _merge==3
*/
drop if _merge~=3

* Reminder - state first available in 1973.
bys year: summ fipsstat

collapse (mean) trustd memnum easyd hardd easyd1 hardd1 [pw=wtssall], by(year fipsstat)
summ

tab1 year
bys year: summ
drop if year < 1973

save socialcap_stateid.dta, replace


log close
clear
