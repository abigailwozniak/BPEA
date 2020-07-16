set more off

log using table5_ym.log, replace

*** Descriptive statistics for NLSY-YM samples

cd ../Data_Tables_5_6_7/.

use US_URate_Data/usurate16up.dta
drop if year > 1999
replace year = year - 1900
summ year
sort year
tempfile tempuryear
save `tempuryear', replace
clear

use NLSY_Datasets/nlsym_tenure.dta

cd ../Table_5/.

keep rpce_hrp* jobten* indten* occten* wkswk_pcy* hgc* black female age* edgrp4* ic* oc* jc* caseid custwt
reshape long rpce_hrp jobten indten occten wkswk_pcy hgc age edgrp4_ ic oc jc, i(caseid) j(year)
*summ

gen lnrhw=ln(rpce_hrp)

*** Create samples 

gen cond=(rpce_hrp~=. & edgrp4_~=. & age~=. & black~=. & jobten~=. & indten~=. & occten~=. & wkswk_pcy > 0)

gen sample1=0
replace sample1=1 if (age>=22 & age<=33) & cond==1
gen sample2=0
replace sample2=1 if (age>=22 & age<=33) & cond==1 & wkswk_pcy >= 26
gen sample3=0
replace sample3=1 if (age>=22 & age<=37) & cond==1 & wkswk_pcy >= 26
summ sample*

drop if sample2==0 
summ sample2 

xi, prefix(_E) i.edgrp4_

** Unweighted means

summ year lnrhw black age _E* jobten indten occten ic oc jc 
tabstat lnrhw black age _E* jobten indten occten ic oc jc year, statistics(mean sd n) format(%8.3f) columns(statistics)

* unadjusted wages for those on job less than one year, etc.

summ rpce_hrp if jobten < 1 & jobten ~=.
summ rpce_hrp if jobten < 0.5 & jobten ~=.

* use constants from regression on age dummies etc as start wages - gives cohort level average start wage, controlling for year effects
xi, prefix(_A) i.age
xi, prefix(_Y) i.year
reg rpce_hrp black _E* _A* _Y* [w=custwt] if jobten < 1 & jobten~=.
reg rpce_hrp black _E* _A* _Y* [w=custwt] if jobten < 0.5 & jobten~=.

reg rpce_hrp black _A* _Y* [w=custwt] if jobten < 1 & jobten~=. & (edgrp4_==1 | edgrp4_==2)
reg rpce_hrp black _A* _Y* [w=custwt] if jobten < 1 & jobten~=. & (edgrp4_==3 | edgrp4_==4)

* Redo controlling for UR and dropping year effects
sort year
merge m:1 year using `tempuryear', keepusing(year usurate16up)
drop if _merge==2
drop _merge
reg rpce_hrp black _E* _A* usurate16up [w=custwt] if jobten < 1 & jobten~=.
reg rpce_hrp black _E* _A* usurate16up [w=custwt] if jobten < 0.5 & jobten~=.
reg rpce_hrp black _A* usurate16up [w=custwt] if jobten < 1 & jobten~=. & (edgrp4_==1 | edgrp4_==2)
reg rpce_hrp black _A* usurate16up [w=custwt] if jobten < 1 & jobten~=. & (edgrp4_==3 | edgrp4_==4)


* use average residual by survey year, after controlling for national UR - doesn't work well here bc sample is aging, wages get noisier as earnings rise even if control for age

reg rpce_hrp black _E* _A* usurate16up [w=custwt] if jobten < 1 & jobten~=.
predict resid12, residuals
reg rpce_hrp black _E* _A* usurate16up [w=custwt] if jobten < 0.5 & jobten~=.
predict resid6, residuals

preserve
collapse resid12 resid6, by(year)
list

restore


** Calculate medians for tenure variables
centile jobten indten occten 

** Get number of respondents in analysis from cluster numbers in regs - N in tenure_returns is xxx

** Mean and median number of job changes per person observed in data, mean and median years in data

drop if jc==.
collapse (count) nyears=jc (sum) num_jc=jc, by(caseid)
summ nyears num_jc
centile nyears num_jc
tab1 nyear num_jc

clear
log close

