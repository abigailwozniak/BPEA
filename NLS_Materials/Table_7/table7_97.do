set more off

log using table7_97.log, replace

/*** Repeat analysis from bdspecs.do in 1997 data ***/
/*** Revised version of do file by same name from Migration Decline analysis. Edited to remove use of or reference to geographic variables. ***/

*set mem 700m

cd ../Data_Tables_5_6_7/.

use US_Urate_Data/usurate16up.dta
drop if year < 1988
summ year
sort year
tempfile tempuryear
save `tempuryear', replace
clear

use US_Urate_Data/usurate16up.dta
drop if year < 1988
summ styear
sort styear
tempfile tempurstyear
save `tempurstyear', replace
clear

use NLSY_Datasets/nlsy97tenure2013.dta

foreach x of numlist 1997/2011 2013 {
  replace hgc`x'=. if hgc`x' < 0
  }

keep  rhrp1* rpce_hrp1* tenureyr1* jobten* indten* occten* hgc* black hisp female age1997 edgrp4* wkswkann* indcen02_* region* married* smsares* pubid custwt
reshape long rhrp1_ rpce_hrp1_ tenureyr1_ jobten indten occten hgc edgrp4_ wkswkann indcen02_ region married smsares, i(pubid) j(year)
summ

gen age = age1997 + (year - 1997)
gen age2 = age^2 

char edgrp4_[omit] 2
xi, prefix(_Y) i.year
xi, prefix(_E) i.edgrp4_

*gen lnrhw=ln(rhrp1_)
gen lnrhw=ln(rpce_hrp1_)

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
tab1 styear if _merge==1
drop if _merge==2
drop _merge
rename usurate16up uinit


*** Calculate min unemp rate during job spell
gen ur1988=5.5
gen ur1989=5.3
gen ur1990=5.6
gen ur1991=6.8
gen ur1992=7.5
gen ur1993=6.9
gen ur1994=6.1
gen ur1995=5.6
gen ur1996=5.4
gen ur1997=4.9
gen ur1998=4.5
gen ur1999=4.2
gen ur2000=4.0
gen ur2001=4.7
gen ur2002=5.8
gen ur2003=6.0
gen ur2004=5.5
gen ur2005=5.1
gen ur2006=4.6
gen ur2007=4.6
gen ur2008=5.8
gen ur2009=9.3
gen ur2010=9.6
gen ur2011=8.9
gen ur2012=8.1
gen ur2013=7.4
gen ur2014=6.2
gen ur2015=5.3


foreach j of numlist 1997/2011 2013 {
   replace ur`j'=. if `j' < styear
   replace ur`j'=. if `j' > year
}

gen ulyr=.
foreach j of numlist 1997/2011 2013 {
   local k = `j' - 1
   replace ulyr = ur`k' if year==`j'
}
summ ulyr

egen umin=rmin(ur1997-ur2013)
*replace umin=ulyr if styear==year
summ umin

drop ur*

gen potexp = age - hgc - 6 if hgc~=. & hgc >= 0
summ hgc potexp if hgc < 0
summ hgc potexp if potexp < 0

* There are a good number of pot exp < 0 - drop these for now
replace potexp=. if potexp < 0

gen potexp2 = potexp^2

*** Create samples to match those in NLS analysis

gen cond=(rhrp1~=. & tenureyr1_~=. & hgc~=. & age~=. & black~=. & hisp~=. & female~=. & jobten~=. & indten~=. & occten~=.)

summ cond rhrp1 tenureyr1_ hgc age black hisp female jobten indten occten wkswkann

*drop if female==1

gen sample1=0
replace sample1=1 if (age>=22 & age<=33) & cond==1
gen sample2=0
replace sample2=1 if (age>=22 & age<=33) & cond==1 & wkswkann >= 26

summ sample*
drop if sample2==0

tab1 year if sample2==1

*** Basic B&D specification, from Grant 2003
* log real hourly wage on indiv FE, pot exp + square, tenure + square, region dummies, 12 ind dummies, union status (omit), marital status, residence in SMSA

* try age and age2 instead of pot exp + square

summ indcen02_
gen indgrp=.
/*
replace indgrp=1 if 170<=indcen02_ & indcen02_<=290
replace indgrp=2 if 370<=indcen02_ & indcen02_<=490
replace indgrp=3 if 570<=indcen02_ & indcen02_<=690
replace indgrp=4 if 770<=indcen02_ & indcen02_<=770
replace indgrp=5 if 1070<=indcen02_ & indcen02_<=3990
replace indgrp=6 if 4070<=indcen02_ & indcen02_<=4590
replace indgrp=7 if 4670<=indcen02_ & indcen02_<=5790
replace indgrp=8 if 5890<=indcen02_ & indcen02_<=5890
replace indgrp=9 if 6070<=indcen02_ & indcen02_<=6390
replace indgrp=10 if 6470<=indcen02_ & indcen02_<=6780
replace indgrp=11 if 6870<=indcen02_ & indcen02_<=7190
replace indgrp=12 if 7270<=indcen02_ & indcen02_<=7790
replace indgrp=13 if 7860<=indcen02_ & indcen02_<=8470
replace indgrp=14 if 8560<=indcen02_ & indcen02_<=8690
replace indgrp=15 if 8770<=indcen02_ & indcen02_<=9290
replace indgrp=15 if 9370<=indcen02_ & indcen02_<=9590
*/
replace indgrp=1 if 17<=indcen02_ & indcen02_<=29
replace indgrp=2 if 37<=indcen02_ & indcen02_<=49
replace indgrp=3 if 57<=indcen02_ & indcen02_<=69
replace indgrp=4 if 77<=indcen02_ & indcen02_<=77
replace indgrp=5 if 107<=indcen02_ & indcen02_<=399
replace indgrp=6 if 407<=indcen02_ & indcen02_<=459
replace indgrp=7 if 467<=indcen02_ & indcen02_<=579
replace indgrp=8 if 589<=indcen02_ & indcen02_<=589
replace indgrp=9 if 607<=indcen02_ & indcen02_<=639
replace indgrp=10 if 647<=indcen02_ & indcen02_<=678
replace indgrp=11 if 687<=indcen02_ & indcen02_<=719
replace indgrp=12 if 727<=indcen02_ & indcen02_<=779
replace indgrp=13 if 786<=indcen02_ & indcen02_<=847
replace indgrp=14 if 856<=indcen02_ & indcen02_<=869
replace indgrp=15 if 877<=indcen02_ & indcen02_<=929
replace indgrp=15 if 937<=indcen02_ & indcen02_<=959

xi, pre(_I) i.indgrp
xi, pre(_R) i.region
xi, pre(_Y) i.year

xtset pubid year

gen trend=year
gen trend2=trend^2

cd ../Table_7/.

xtreg lnrhw ucurr uinit umin age age2 jobten job2 trend trend2 if female==0 [w=custwt], fe cluster(pubid)
*outreg using bd1997.doc, se keep(ucurr uinit umin) replace
outreg using Output/bd1997.doc, se keep(ucurr uinit umin) replace
qui xtreg lnrhw ucurr uinit umin age age2 jobten job2 trend trend2 if female==1 [w=custwt], fe cluster(pubid)
*outreg using bd1997.doc, se keep(ucurr uinit umin) merge replace
outreg using Output/bd1997.doc, se keep(ucurr uinit umin) merge replace
qui xtreg lnrhw ucurr uinit umin age age2 jobten job2 trend trend2 [w=custwt], fe cluster(pubid)
*outreg using bd1997.doc, se keep(ucurr uinit umin) merge replace
outreg using Output/bd1997.doc, se keep(ucurr uinit umin) merge replace

log close
clear


