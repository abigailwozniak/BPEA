set more off

log using table5_79.log, replace

*** Descriptive statistics for NLSY79 samples
/*** UPDATED version of file with same name that produced T5 for NBER paper - removes geo coded variables ***/
/*** Big change is that omitting Rs who have a main jobs that is not CPS job reduces number of unique obs from about 4700 to about 2900 - NLSY sample size now similar to NLSYM and NLSY97 ***/

cd ../Data_Tables_5_6_7/.

use US_URate_Data/usurate16up.dta

drop if year > 1999
replace year = year - 1900
summ year
sort year
tempfile tempuryear
save `tempuryear', replace
clear

use NLSY_Datasets/nlsy79tenure.dta

cd ../Table_5/.

keep rcpshrp* rpce_cpshrp* tenureyr1* jobten* indten* occten* hgcrev* esr_key* black hisp female age* edgrp4* wkswk_pcy* ic* oc* jc* job1iscps* caseid custwt
reshape long rcpshrp rpce_cpshrp tenureyr1_ jobten indten occten hgcrev esr_key age edgrp4_ wkswk_pcy ic oc jc job1iscps, i(caseid) j(year)
*summ

*gen lnrhw=ln(rcpshrp)
gen lnrhw=ln(rpce_cpshrp)

*** Create samples 

gen cond=(rpce_cpshrp~=. & tenureyr1_~=. & edgrp4_~=. & age~=. & black~=. & hisp~=. & female~=. & jobten~=. & indten~=. & occten~=.)

gen sample1=0
replace sample1=1 if (age>=22 & age<=33) & cond==1
gen sample2=0
replace sample2=1 if (age>=22 & age<=33) & cond==1 & wkswk_pcy >= 26
gen sample3=0
replace sample3=1 if (age>=22 & age<=37) & cond==1 & wkswk_pcy >= 26
summ sample*

drop if sample2==0 | female==1
summ sample2 female

xi, prefix(_E) i.edgrp4_

** Unweighted means

summ year lnrhw black hisp female age _E* tenureyr1_ jobten indten occten ic oc jc 
tabstat lnrhw black hisp age _E* jobten indten occten ic oc jc tenureyr1_ female year, statistics(mean sd n) format(%8.3f) columns(statistics)

* unadjusted wages for those on job less than one year, etc.

summ rpce_cpshrp if tenureyr1_ < 1 & tenureyr1_ ~=.
summ rpce_cpshrp if tenureyr1_ < 0.5 & tenureyr1_ ~=.

* use constants from regression on age dummies - gives cohort level average start wage, controlling for year effects
xi, prefix(_A) i.age
xi, prefix(_Y) i.year
reg rpce_cpshrp black hisp _E* _A* _Y* [w=custwt] if tenureyr1_ < 1 & tenureyr1_~=.
reg rpce_cpshrp black hisp _E* _A* _Y* [w=custwt] if tenureyr1_ < 0.5 & tenureyr1_~=.

reg rpce_cpshrp black hisp _A* _Y* [w=custwt] if tenureyr1_ < 1 & tenureyr1_~=. & (edgrp4_==1 | edgrp4_==2)
reg rpce_cpshrp black hisp _A* _Y* [w=custwt] if tenureyr1_ < 1 & tenureyr1_~=. & (edgrp4_==3 | edgrp4_==4)

* Redo controlling for UR and dropping year effects
sort year
merge m:1 year using `tempuryear', keepusing(year usurate16up)
drop if _merge==2
drop _merge
reg rpce_cpshrp black hisp _E* _A* usurate16up [w=custwt] if tenureyr1_ < 1 & tenureyr1_~=.
reg rpce_cpshrp black hisp _E* _A* usurate16up [w=custwt] if tenureyr1_ < 0.5 & tenureyr1_~=.
reg rpce_cpshrp black hisp _A* usurate16up [w=custwt] if tenureyr1_ < 1 & tenureyr1_~=. & (edgrp4_==1 | edgrp4_==2)
reg rpce_cpshrp black hisp _A* usurate16up [w=custwt] if tenureyr1_ < 1 & tenureyr1_~=. & (edgrp4_==3 | edgrp4_==4)

* use average residual by survey year, after controlling for national UR

reg rpce_cpshrp black _E* _A* usurate16up [w=custwt] if jobten < 1 & jobten~=.
predict resid12, residuals
reg rpce_cpshrp black _E* _A* usurate16up [w=custwt] if jobten < 0.5 & jobten~=.
predict resid6, residuals

preserve
collapse resid12 resid6, by(year)
list

restore

** Calculate medians for tenure variables
centile tenureyr1_ jobten indten occten 

** Get number of respondents in analysis from cluster numbers in regs - N in tenure_returns is 2965

** Mean and median number of job changes per person observed in data, mean and median years in data

drop if jc==.
collapse (count) nyears=jc (sum) num_jc=jc, by(caseid)
summ nyears num_jc
centile nyears num_jc
tab1 nyear num_jc


log close
clear
