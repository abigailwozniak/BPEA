* generate a dataset of state-level CPS covariates

set trace off
set more 1 
capture log close
clear
set linesize 250

log using cpscovariates.log, replace

*use cps_00026.dta, clear
use Input/cps_00026.dta, clear

quietly for var age: replace X = . if qX==1 | qX==3

gen age17m = age<=17 if age~=.
gen age1822 = age>=18 & age<=22 if age~=.
gen age2334 = age>=23 & age<=34 if age~=.
gen age3544 = age>=35 & age<=44 if age~=.
gen age4564 = age>=45 & age<=64 if age~=.
gen age64p = age>=65 if age~=.


* hsdeg includes respondents who report high school but diploma is unclear
replace educ = . if qeduc==1 
replace educ = . if educ==1 | educ==999
gen lths = educ>=2 & educ<=71 if educ~=.
gen hsdeg = (educ==72 | educ==73) &  educ~=.
gen somecol = educ>=80 & educ<=110 if educ~=.
gen collplus = educ>=111 & educ<=125 if educ~=.

replace marst = . if qmarst>=2 & qmarst<=5
gen married = marst==1 if marst~=. & age>=18 & age~=.
gen single = marst==6 if marst~=. & age>=18 & age~=.

replace ownershp=. if ownershp==0
gen owner = ownershp==10 if ownershp~=. 

replace sex = . if qsex>=1 & qsex<=3
gen female = sex==2 if sex~=.

gen primemale = age>=25 & age<=54 & female==0 if age~=. & sex~=.
gen primefemale = age>=25 & age<=54 & female==1 if age~=. & sex~=.

gen mfg = ind1990>=100 & ind1990<=392 if ind1990~=.
gen serv = ind1990>=721 & ind1990<=893 if ind1990~=.
gen retail = ind1990>=580 & ind1990<=691 if ind1990~=.
gen ag = ind1990>=10 & ind1990<=32 if ind1990~=.
gen fire = ind1990>=700 & ind1990<=712 if ind1990~=.

replace classwkr = . if classwkr==0 | classwkr==99 | (qclasswk>=1 & qclasswk<=9)
gen selfemp =  classwkr>=10 & classwkr<=14 if classwkr<=23
gen gov = classwkr>=24 & classwkr<=28 if classwkr<=28

replace occ1990 = . if qocc>=2 & qocc<=4
replace occ1990 = . if age<=17
gen manprof = occ1990>=3 & occ1990<=199 if occ1990~=.
gen techocc = occ1990>=203 & occ1990<=235 if occ1990~=.
gen salesocc = occ1990>=243 & occ1990<=290 if occ1990~=.
gen adminocc = occ1990>=303 & occ1990<=391 if occ1990~=.
gen servocc = occ1990>=405 & occ1990<=469 if occ1990~=.
gen prodocc = occ1990>=503 & occ1990<=699 if occ1990~=.
gen opocc = occ1990>=703 & occ1990<=779 if occ1990~=.
gen military = occ1990==905 if occ1990~=.

gen af = popstat==2 if popstat<=2
tab military af

gen fborn = citizen==2 | citizen==3 if citizen~=.

gen inschool = schlcoll>=1 & schlcoll<=4 if schlcoll~=0

replace migrate1 = . if (qmigrat1>=1 & qmigrat1<=4) | year==1995 | year==1963
gen smigrant = 1 if migrate1==5
replace smigrant = 0 if migrate1>=1 & migrate1<=4

replace numemps = . if qnumemps==1
gen empchangeipums = 1 if numemps==2 | numemps==3
replace empchangeipums = 0 if numemps==1

replace incwage = . if qincwage>=1 & qincwage<=3
replace incwage = . if incwage==9999999 | incwage==9999998 | incwage==0

replace wtsupp = . if wtsupp<0
*save temp, replace
save Output/temp, replace
gen ones = 1
collapse (sum) pop=ones (mean) age17m-age64p lths-collplus married single female mfg serv retail ag fire gov selfemp manprof-military fborn smigrant inschool empchangeipums owner primemale primefemale (p90) p90incwage=incwage (p10) p10incwage=incwage [w=wtsupp], by(statefip year)
replace inschool = . if year<=1985
sort statefip year
quietly for var p90incwage p10incwage: quietly by statefip: gen X1 = X[_n+1]
gen p9010incwage1 = log(p90incwage1/p10incwage1)
rename statefip state
*save cpscovariates, replace
save Output/cpscovariates, replace

*use temp, clear
use Output/temp, clear
collapse (mean) smigrant empchangeipums [w=wtsupp] if age>=35 & age<=64, by(statefip year)
rename statefip state
*save ipums3564, replace
save Output/ipums3564, replace

*use temp, clear
use Output/temp, clear
replace whymove = . if qwhymove>=1 & qwhymove<=3
gen famreason = smigrant==1 & whymove>=1 & whymove<=3 if whymove~=. & smigrant<=1
gen empreason = smigrant==1 & whymove>=4 & whymove<=8 if whymove~=. & smigrant<=1
gen housreason = smigrant==1 & whymove>=9 & whymove<=13 if whymove~=. & smigrant<=1
gen othreason = smigrant==1 & whymove>=14 & whymove<=19 if whymove~=. & smigrant<=1
gen empreason2 = smigrant==1 & whymove>=4 & whymove<=5 if whymove~=. & smigrant<=1

sum empreason empchangeipums if smigrant==1  [w=wtsupp]
sum empreason empchangeipums if smigrant==1 & empreason~=. [w=wtsupp]
sum empreason if smigrant==1 & empchangeipums==0 [w=wtsupp]
sum empreason if smigrant==1 & age>=22 [w=wtsupp]

gen smig14c = smigrant if age>=14 & military==0
collapse (mean)  smigrant smig14c famreason empreason* housreason othreason empchangeipums [w=wtsupp], by(year)

*graph twoway line smigrant year if year, saving(temp, replace) xlab(1965(5)2015)
graph twoway line smigrant year if year, saving(Output/temp, replace) xlab(1965(5)2015)
*graph twoway line famreason empreason empreason2 housreason othreason year if year>=1999, saving(temp2, replace)
graph twoway line famreason empreason empreason2 housreason othreason year if year>=1999, saving(Output/temp2, replace)

*save cpsmig, replace
save Output/cpsmig, replace

*insheet using bds_e_st_releast.csv, clear
insheet using Input/bds_e_st_releast.csv, clear
rename year2 year
keep year state job_creation_rate job_destruction_rate
rename job_creation_rate jcr
rename job_destruction_rate jdr

*merge 1:1 state year using cpscovariates
merge 1:1 state year using Output/cpscovariates
drop _merge
*save cpscovariates, replace
save Output/cpscovariates, replace

quietly log close

