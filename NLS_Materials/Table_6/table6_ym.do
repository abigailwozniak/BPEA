set more off

log using table6_ym.log, replace

*** Descriptive statistics for NLSY-YM samples

cd ../Data_Tables_5_6_7/.

use NLSY_Datasets/nlsym_tenure.dta

cd ../Table_6/.

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
tab1 year
summ sample2 

gen age2 = age^2 
qui gen ind2=indten*indten
qui gen occ2=occten*occten
qui gen job2=jobten*jobten

char edgrp4_[omit] 2
xi, prefix(_E) i.edgrp4_
xi, prefix(_Y) i.year

tab1 year if sample2==1

* ind, occ, job with individual FEs - same as NBER spec (reported all years) but excludes locten and adds education group dummies
* Other changes were made to data - esp fixed default coding of missing wages as negatives

xtset caseid year
xtreg lnrhw jobten job2 indten ind2 occten occ2 age age2 _E* _Y* if sample2==1 [w=custwt], fe cluster(caseid)

* compute implied returns going from two to three years of tenure and standard errors 
nlcom 1*_b[indten] + 5*_b[ind2]
nlcom 1*_b[occten] + 5*_b[occ2]
nlcom 1*_b[jobten] + 5*_b[job2]

log close
clear


