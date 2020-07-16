set more off

log using table7_79.log, replace

/*** Estimates of B&D contracting models ***/
/*** Revised version of do file by same name from Migration Decline analysis. Edited to remove use of or reference to geographic variables. ***/

*set mem 700m

cd ../Data_Tables_5_6_7/.

use US_Urate_Data/usurate16up.dta
drop if year > 1999
replace year = year - 1900
summ year
sort year
tempfile tempuryear
save `tempuryear', replace
clear

use US_Urate_Data/usurate16up.dta
drop if year > 1999
replace styear = styear - 1900
summ styear
sort styear
tempfile tempurstyear
save `tempurstyear', replace
clear

use NLSY_Datasets/nlsy79tenure.dta

foreach x of numlist 80/94 {
  replace hgcrev`x'=. if hgcrev`x' < 0
}

keep rcpshrp* rpce_cpshrp* tenureyr1* jobten* indten* occten* hgcrev* esr_key* black hisp female age79 edgrp4* wkswk_pcy* job1iscps* cpsind70* region* married* smsares* caseid custwt
reshape long rcpshrp rpce_cpshrp tenureyr1_ jobten indten occten hgcrev esr_key edgrp4_ wkswk_pcy job1iscps cpsind70_ region married smsares, i(caseid) j(year)
summ

gen age = age79 + (year - 79)
gen age2 = age^2 

char edgrp4_[omit] 2
xi, prefix(_Y) i.year
xi, prefix(_E) i.edgrp4_

*gen lnrhw=ln(rcpshrp)
gen lnrhw=ln(rpce_cpshrp)

qui gen ind2=indten*indten
qui gen occ2=occten*occten
qui gen job2=jobten*jobten


*** Merge in current and initial unemployment rate

sort year
merge m:1 year using `tempuryear', keepusing(year usurate16up)
drop if _merge==2
drop _merge
rename usurate16up ucurr

gen styear=round(year-tenureyr1_)
summ styear
sort styear
merge m:1 styear using `tempurstyear', keepusing(styear usurate16up)
drop if _merge==2
drop _merge
rename usurate16up uinit

*** Calculate min unemp rate during job spell

gen ur70=4.9
gen ur71=5.9
gen ur72=5.6
gen ur73=4.9
gen ur74=5.6
gen ur75=8.5
gen ur76=7.7
gen ur77=7.1
gen ur78=6.1
gen ur79=5.8
gen ur80=7.1
gen ur81=7.6
gen ur82=9.7
gen ur83=9.6
gen ur84=7.5
gen ur85=7.2
gen ur86=7.0
gen ur87=6.2
gen ur88=5.5
gen ur89=5.3
gen ur90=5.6
gen ur91=6.8
gen ur92=7.5
gen ur93=6.9
gen ur94=6.1


forvalues j = 70/94 {
   replace ur`j'=. if `j' < styear
   replace ur`j'=. if `j' > year
}

gen ulyr=.
forvalues j = 79/94 {
   local k = `j' - 1
   replace ulyr = ur`k' if year==`j'
}
summ ulyr

egen umin=rmin(ur70-ur94)
summ umin if styear==year
*replace umin=ulyr if styear==year
summ umin
drop ur*

gen potexp = age - hgcrev - 6 if hgcrev~=. & hgcrev >= 0
summ hgcrev potexp if hgcrev < 0
summ hgcrev potexp if potexp < 0

* There are a good number of pot exp < 0 - drop these for now
gen potexpb=potexp
replace potexp=. if potexp < 0

gen potexp2 = potexp^2
gen potexpb2=potexpb^2

*** Create samples to match those in NLS analysis

gen cond=(rcpshrp~=. & tenureyr1_~=. & hgcrev~=. & age~=. & black~=. & hisp~=. & female~=. & jobten~=. & indten~=. & occten~=.)

*drop if female==1
*bysort year: tab1 job1iscps
drop if job1iscps==0

gen sample1=0
replace sample1=1 if (age>=22 & age<=33) & cond==1
gen sample2=0
replace sample2=1 if (age>=22 & age<=33) & cond==1 & wkswk_pcy >= 26
gen sample3=0
replace sample3=1 if (age>=22 & age<=37) & cond==1 & wkswk_pcy >= 26

summ sample*
*drop if sample2==0

tab1 year if sample2==1

*** Basic B&D specification, from Grant 2003
* log real hourly wage on indiv FE, pot exp + square, tenure + square, region dummies, 12 ind dummies, union status (omit), marital status, residence in SMSA

* try age and age2 instead of pot exp + square

summ cpsind70_
gen indgrp=.
replace indgrp=1 if 0<=cpsind70_ & cpsind70_<=28
replace indgrp=2 if 47<=cpsind70_ & cpsind70_<=57
replace indgrp=3 if 67<=cpsind70_ & cpsind70_<=77
replace indgrp=4 if 107<=cpsind70_ & cpsind70_<=398
replace indgrp=5 if 407<=cpsind70_ & cpsind70_<=479
replace indgrp=6 if 507<=cpsind70_ & cpsind70_<=698
replace indgrp=7 if 707<=cpsind70_ & cpsind70_<=718
replace indgrp=8 if 727<=cpsind70_ & cpsind70_<=759
replace indgrp=9 if 769<=cpsind70_ & cpsind70_<=798
replace indgrp=10 if 807<=cpsind70_ & cpsind70_<=809
replace indgrp=11 if 828<=cpsind70_ & cpsind70_<=897
replace indgrp=12 if 907<=cpsind70_ & cpsind70_<=937

xi, pre(_I) i.indgrp
xi, pre(_R) i.region
xi, pre(_Y) i.year

xtset caseid year

summ black hisp

gen trend=year
gen trend2=trend^2

cd ../Table_7/.

xtreg lnrhw ucurr uinit umin age age2 jobten job2 trend trend2 if female==0 & sample2==1 [w=custwt], fe cluster(caseid)
*outreg using bd1979.doc, se keep(ucurr uinit umin) replace
outreg using Output/bd1979.doc, se keep(ucurr uinit umin) replace
qui xtreg lnrhw ucurr uinit umin age age2 jobten job2 trend trend2 if female==1 & sample2==1 [w=custwt], fe cluster(caseid)
*outreg using bd1979.doc, se keep(ucurr uinit umin) merge
outreg using Output/bd1979.doc, se keep(ucurr uinit umin) merge
qui xtreg lnrhw ucurr uinit umin age age2 jobten job2 trend trend2 if sample2==1 [w=custwt], fe cluster(caseid)
*outreg using bd1979.doc, se keep(ucurr uinit umin) merge
outreg using Output/bd1979.doc, se keep(ucurr uinit umin) merge

log close
clear


