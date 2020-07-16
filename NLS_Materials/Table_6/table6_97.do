set more off

log using table6_97.log, replace

/*** Regression estimation of returns to various forms of tenure in NLSY 1997 ***/
/*** UPDATED version of file with same name that produced T7 for NBER paper ***/

cd ../Data_Tables_5_6_7/.

use NLSY_Datasets/nlsy97tenure2013.dta

cd ../Table_6/.

keep rhrp1* rpce_hrp1* tenureyr1* jobten* indten* occten* edgrp4* black hisp female age* edgrp4* wkswkann* pubid custwt
reshape long rhrp1_ rpce_hrp1_ tenureyr1_ jobten indten occten age edgrp4_ wkswkann, i(pubid) j(year)
summ

gen age2 = age^2 

char edgrp4_[omit] 2
xi, prefix(_Y) i.year
xi, prefix(_E) i.edgrp4_

*gen lnrhw=ln(rhrp1_)
gen lnrhw=ln(rpce_hrp1_)

qui gen ind2=indten*indten
qui gen occ2=occten*occten
qui gen job2=jobten*jobten

*** Create samples 

gen cond=(rpce_hrp1_~=. & tenureyr1_~=. & edgrp4_~=. & age~=. & black~=. & hisp~=. & female~=. & jobten~=. & indten~=. & occten~=.)
summ age wkswkann if cond==1

drop if female==1

gen sample1=0
replace sample1=1 if (age>=22 & age<=33) & cond==1
gen sample2=0
replace sample2=1 if (age>=22 & age<=33) & cond==1 & wkswkann >= 26

summ sample*

tab1 year if sample2==1

* ind, occ, job with individual FEs - same as NBER spec (reported all years) but excludes locten and adds education group dummies
* Other changes were made to data - esp fixed default coding of missing wages as negatives

xtset pubid year
xtreg lnrhw jobten job2 indten ind2 occten occ2 _E* _Y* if sample2==1 [w=custwt], fe cluster(pubid)

* compute implied returns going from two to three years of tenure and standard errors 
nlcom 1*_b[indten] + 5*_b[ind2]
nlcom 1*_b[occten] + 5*_b[occ2]
nlcom 1*_b[jobten] + 5*_b[job2]


xtreg lnrhw jobten job2 indten ind2 occten occ2 _E* _Y* if sample2==1 & year < 2008 [w=custwt], fe cluster(pubid)

* compute implied returns going from two to three years of tenure and standard errors 
nlcom 1*_b[indten] + 5*_b[ind2]
nlcom 1*_b[occten] + 5*_b[occ2]
nlcom 1*_b[jobten] + 5*_b[job2]

log close
clear

