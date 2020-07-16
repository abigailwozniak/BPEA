set more off

log using table5_97.log, replace

/*** Descriptive statistics for the NLSY 1997 ***/
/*** UPDATED version of file with same name that produced T5 for NBER paper ***/
/*** Big change from NBER is that corrected default coding of missing wages as negative - but does not affect sample size much ***/

cd ../Data_Tables_5_6_7/.

use US_URate_Data/usurate16up.dta
drop if year < 1988
summ year
sort year
tempfile tempuryear
save `tempuryear', replace
clear

use NLSY_Datasets/nlsy97tenure2013.dta

cd ../Table_5/.

keep rhrp1* rpce_hrp1* tenureyr1* jobten* indten* occten* edgrp4* black hisp female age* edgrp4* wkswkann* ic* oc* jc* pubid custwt
reshape long rhrp1_ rpce_hrp1_ tenureyr1_ jobten indten occten age edgrp4_ wkswkann ic oc jc, i(pubid) j(year)
*summ

*gen lnrhw=ln(rhrp1_)
gen lnrhw=ln(rpce_hrp1_)

*** Create samples 

gen cond=(rpce_hrp1_~=. & tenureyr1_~=. & edgrp4_~=. & age~=. & black~=. & hisp~=. & female~=. & jobten~=. & indten~=. & occten~=.)
summ age wkswkann if cond==1

gen sample1=0
replace sample1=1 if (age>=22 & age<=33) & cond==1
gen sample2=0
replace sample2=1 if (age>=22 & age<=33) & cond==1 & wkswkann >= 26

summ sample*
drop if sample2==0 | female==1
summ sample2 female

xi, prefix(_E) i.edgrp4_

** Unweighted means

summ year lnrhw black hisp female age _E* tenureyr1_ jobten indten occten ic oc jc 
tabstat lnrhw black hisp age _E* jobten indten occten ic oc jc tenureyr1_ female year, statistics(mean sd n) format(%8.3f) columns(statistics)
tabstat lnrhw black hisp age _E* jobten indten occten ic oc jc tenureyr1_ female year if year < 2008, statistics(mean sd n) format(%8.3f) columns(statistics)

* unadjusted wages for those on job less than one year, etc.

summ rpce_hrp1_ if tenureyr1_ < 1 & tenureyr1_ ~=.
summ rpce_hrp1_ if tenureyr1_ < 0.5 & tenureyr1_ ~=.

* use constants from regression on age dummies - gives cohort level average start wage, controlling for year effects
xi, prefix(_A) i.age
xi, prefix(_Y) i.year
reg rpce_hrp1_ black hisp _E* _A* _Y* [w=custwt] if tenureyr1_ < 1 & tenureyr1_~=.
reg rpce_hrp1_ black hisp _E* _A* _Y* [w=custwt] if tenureyr1_ < 0.5 & tenureyr1_~=.

reg rpce_hrp1_ black hisp _A* _Y* [w=custwt] if tenureyr1_ < 1 & tenureyr1_~=. & (edgrp4_==1 | edgrp4_==2)
reg rpce_hrp1_ black hisp _A* _Y* [w=custwt] if tenureyr1_ < 1 & tenureyr1_~=. & (edgrp4_==3 | edgrp4_==4)

* Redo controlling for UR and dropping year effects
sort year
merge m:1 year using `tempuryear', keepusing(year usurate16up)
drop if _merge==2
drop _merge
reg rpce_hrp1_ black hisp _E* _A* usurate16up [w=custwt] if tenureyr1_ < 1 & tenureyr1_~=.
reg rpce_hrp1_ black hisp _E* _A* usurate16up [w=custwt] if tenureyr1_ < 0.5 & tenureyr1_~=.
reg rpce_hrp1_ black hisp _A* usurate16up [w=custwt] if tenureyr1_ < 1 & tenureyr1_~=. & (edgrp4_==1 | edgrp4_==2)
reg rpce_hrp1_ black hisp _A* usurate16up [w=custwt] if tenureyr1_ < 1 & tenureyr1_~=. & (edgrp4_==3 | edgrp4_==4)

* use average residual by survey year, after controlling for national UR

reg rpce_hrp1_ black _E* _A* usurate16up [w=custwt] if jobten < 1 & jobten~=.
predict resid12, residuals
reg rpce_hrp1_ black _E* _A* usurate16up [w=custwt] if jobten < 0.5 & jobten~=.
predict resid6, residuals

preserve
collapse resid12 resid6, by(year)
list

restore


** Do medians for tenure variables

centile tenureyr1_ jobten indten occten 

** Get number of respondents in analysis from cluster numbers in regs - N from tenure_returns is 2917

** Mean and median number of job changes per person observed in data, mean and median years in data

drop if jc==.
collapse (count) nyears=jc (sum) num_jc=jc, by(pubid)
summ nyears num_jc
centile nyears num_jc
tab1 nyears num_jc

log close
clear
