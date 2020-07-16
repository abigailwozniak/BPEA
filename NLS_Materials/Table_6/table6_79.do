set more off

log using table6_79.log, replace

/*** Regression estimation of returns to various forms of tenure in NLSY ***/
/*** UPDATED version of file with same name that produced T7 for NBER paper ***/

cd ../Data_Tables_5_6_7/.

use NLSY_Datasets/nlsy79tenure.dta

cd ../Table_6/.

foreach x of numlist 80/94 {
  replace hgcrev`x'=. if hgcrev`x' < 0
}

keep rcpshrp* rpce_cpshrp* tenureyr1* jobten* indten* occten* hgcrev* esr_key* black hisp female age* edgrp4* wkswk_pcy* job1iscps* caseid custwt
reshape long rcpshrp rpce_cpshrp tenureyr1_ jobten indten occten hgcrev esr_key age edgrp4_ wkswk_pcy job1iscps, i(caseid) j(year)
summ

* CHANGE from NBER analysis - use age calculated using birth and interview months
gen age2 = age^2 

char edgrp4_[omit] 2
xi, prefix(_Y) i.year
xi, prefix(_E) i.edgrp4_

* CHANGE from NBER analysis - use pce deflator
*gen lnrhw=ln(rcpshrp)
gen lnrhw=ln(rpce_cpshrp)

qui gen ind2=indten*indten
qui gen occ2=occten*occten
qui gen job2=jobten*jobten


*** Create samples 

gen cond=(lnrhw~=. & tenureyr1_~=. & hgcrev~=. & age~=. & black~=. & hisp~=. & female~=. & jobten~=. & indten~=. & occten~=.)

drop if female==1

gen sample1=0
replace sample1=1 if (age>=22 & age<=33) & cond==1
gen sample2=0
replace sample2=1 if (age>=22 & age<=33) & cond==1 & wkswk_pcy >= 26
gen sample3=0
replace sample3=1 if (age>=22 & age<=37) & cond==1 & wkswk_pcy >= 26

summ sample*

tab1 year if sample2==1

* When cond applied, all retained obs have job1iscps=1
summ job1iscps if cond==0
summ job1iscps if cond==1


* ind, occ, job - with person FEs (This is NBER specification minus location tenure measures, plus added education)

xtset caseid year
xtreg lnrhw jobten job2 indten ind2 occten occ2 _E* _Y* if sample2==1 [w=custwt], fe cluster(caseid)

* compute implied returns going from two to three years of tenure and standard errors 
* These are for 22 to 33 year olds (main sample)
nlcom 1*_b[indten] + 5*_b[ind2]
nlcom 1*_b[occten] + 5*_b[occ2]
nlcom 1*_b[jobten] + 5*_b[job2]

log close
clear

