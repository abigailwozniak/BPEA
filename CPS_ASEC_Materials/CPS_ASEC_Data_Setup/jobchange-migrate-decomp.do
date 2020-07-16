set more off
capture log close
clear

***Creates job changing and migration rates using March CPS data 
***Uses this data to run cell-level regressions for the decomps shown in Fig 5 and fig A4
***For job changing (2+ employers), uses IPUMS data.  For migration, uses UNICON data.

use mcr/scratch-m1cls01/data/cps/brookings-dynamism/dynam/ipums/cps_00046.dta, clear
drop if wtsupp<=0 

sort year ind
merge year ind using research/brookings-dynamism/dta/ind1950-crosswalk.dta, keep(indgroup ind1950)
keep if _merge==3
drop if indgroup==.
drop _merge

rename ind indnow
rename indgroup indgroupnow
rename ind1950 ind1950now
rename indly ind
sort year ind
merge year ind using research/brookings-dynamism/dta/ind1950-crosswalk.dta, keep(indgroup ind1950)
keep if _merge==3
drop if indgroup==.
drop _merge

rename ind indly
rename indgroup indgrouply
rename ind1950 ind1950ly
rename indnow ind
rename indgroupnow indgroup
rename ind1950now ind1950

sort year occ
merge year occ using research/brookings-dynamism/dta/occ1950-crosswalk.dta, keep(occgroup occ1950)
keep if _merge==3
drop if occgroup==.
drop _merge

rename occ occnow
rename occgroup occgroupnow
rename occ1950 occ1950now
rename occly occ
sort year occ
merge year occ using research/brookings-dynamism/dta/occ1950-crosswalk.dta, keep(occgroup occ1950)
keep if _merge==3
drop if occgroup==.
drop _merge

rename occ occly
rename occgroup occgrouply
rename occ1950 occ1950ly
rename occnow occ
rename occgroupnow occgroup
rename occ1950now occ1950


gen edgroup=.

replace edgroup=1 if educ<=60
replace edgroup=2 if educ>60 & educ<=73
replace edgroup=3 if educ>=80 & educ<=100
replace edgroup=4 if educ>=110

assert edgroup!=.

gen margroup=.

replace margroup=1 if marst!=6
replace margroup=2 if marst==6 

assert margroup!=.

gen indchange=(ind1950!=ind1950ly) if wkswork2>0 & wkswork2!=9 & occ>0 & ind>0 & occly>0 & indly>0  
gen occchange=(occ1950!=occ1950ly) if wkswork2>0 & wkswork2!=9 & occ>0 & ind>0 & occly>0 & indly>0  

gen empchange=(numemps>=2 & numemps<=3) if wkswork2>0 & wkswork2!=9 & occ>0 & ind>0 & occly>0 & indly>0  & numemps>=1



keep if age>=18
replace age=80 if age>=80
sort year sex age edgroup margroup indgrouply
gen n=wtsupp
collapse (mean) indchange occchange empchange (rawsum) n [aw=wtsupp], by(year sex age edgroup margroup indgrouply)
sort year sex age edgroup margroup indgroup
tempfile tempipums
save `tempipums', replace

use mcr/scratch-m1cls01/data/cps/brookings-dynamism/dynam/ipums/cps_00047.dta, clear
drop if wtsupp<=0 

sort year ind
merge year ind using research/brookings-dynamism/dta/ind1950-crosswalk.dta, keep(indgroup ind1950)
keep if _merge==3
drop if indgroup==.
drop _merge

rename ind indnow
rename indgroup indgroupnow
rename ind1950 ind1950now
rename indly ind
sort year ind
merge year ind using research/brookings-dynamism/dta/ind1950-crosswalk.dta, keep(indgroup ind1950)
keep if _merge==3
drop if indgroup==.
drop _merge

rename ind indly
rename indgroup indgrouply
rename ind1950 ind1950ly
rename indnow ind
rename indgroupnow indgroup
rename ind1950now ind1950

sort year occ
merge year occ using research/brookings-dynamism/dta/occ1950-crosswalk.dta, keep(occgroup occ1950)
keep if _merge==3
drop if occgroup==.
drop _merge

rename occ occnow
rename occgroup occgroupnow
rename occ1950 occ1950now
rename occly occ
sort year occ
merge year occ using research/brookings-dynamism/dta/occ1950-crosswalk.dta, keep(occgroup occ1950)
keep if _merge==3
drop if occgroup==.
drop _merge

rename occ occly
rename occgroup occgrouply
rename occ1950 occ1950ly
rename occnow occ
rename occgroupnow occgroup
rename occ1950now occ1950


gen edgroup=.

replace edgroup=1 if educ<=60
replace edgroup=2 if educ>60 & educ<=73
replace edgroup=3 if educ>=80 & educ<=100
replace edgroup=4 if educ>=110

assert edgroup!=.

gen margroup=.

replace margroup=1 if marst!=6
replace margroup=2 if marst==6 

assert margroup!=.

gen indchange=(ind1950!=ind1950ly) if wkswork2>0 & wkswork2!=9 & occ>0 & ind>0 & occly>0 & indly>0  
gen occchange=(occ1950!=occ1950ly) if wkswork2>0 & wkswork2!=9 & occ>0 & ind>0 & occly>0 & indly>0  

gen empchange=(numemps>=2 & numemps<=3) if wkswork2>0 & wkswork2!=9 & occ>0 & ind>0 & occly>0 & indly>0  & numemps>=1



keep if age>=18
replace age=80 if age>=80
sort year sex age edgroup margroup indgrouply
gen n=wtsupp
collapse (mean) indchange occchange empchange (rawsum) n [aw=wtsupp], by(year sex age edgroup margroup indgrouply)
sort year sex age edgroup margroup indgroup
tempfile temp80
save `temp80', replace

foreach yr in 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13 {

if `yr'!=88 & (`yr'>=79 | `yr'<=13) {
use mcr/scratch-m1cls01/data/cps/inequality/mar`yr'.dta, clear
}

if `yr'==88{
use mcr/scratch-m1cls01/data/cps/inequality/mar88b.dta, clear
}

if `yr'>16 {
gen year=1900+`yr' 
}

if `yr'<=16 {
gen year=2000+`yr'
}

sort year ind
merge year ind using research/brookings-dynamism/dta/ind1950-crosswalk.dta, keep(indgroup ind1950)
keep if _merge==3
drop if indgroup==.
drop _merge

rename ind indnow
rename indgroup indgroupnow
rename ind1950 ind1950now
rename indly ind
sort year ind
merge year ind using research/brookings-dynamism/dta/ind1950-crosswalk.dta, keep(indgroup ind1950)
keep if _merge==3
drop if indgroup==.
drop _merge

rename ind indly
rename indgroup indgrouply
rename ind1950 ind1950ly
rename indnow ind
rename indgroupnow indgroup
rename ind1950now ind1950

sort year occ
merge year occ using research/brookings-dynamism/dta/occ1950-crosswalk.dta, keep(occgroup occ1950)
keep if _merge==3
drop if occgroup==.
drop _merge

rename occ occnow
rename occgroup occgroupnow
rename occ1950 occ1950now
rename occly occ
sort year occ
merge year occ using research/brookings-dynamism/dta/occ1950-crosswalk.dta, keep(occgroup occ1950)
keep if _merge==3
drop if occgroup==.
drop _merge

rename occ occly
rename occgroup occgrouply
rename occ1950 occ1950ly
rename occnow occ
rename occgroupnow occgroup
rename occ1950now occ1950


if `yr'<=91 & `yr'>15 {
gen edgroup=.

replace edgroup=1 if year>=1988 & year<=1991 & grdhi<12
replace edgroup=2 if year>=1988 & year<=1991 & grdhi==12
replace edgroup=3 if year>=1988 & year<=1991 & grdhi>=13 & grdhi<=15
replace edgroup=4 if year>=1988 & year<=1991 & grdhi>=16

replace edgroup=1 if year<=1987 & grdhi<13
replace edgroup=2 if year<=1987 & grdhi==13
replace edgroup=3 if year<=1987 & grdhi>=14 & grdhi<=16
replace edgroup=4 if year<=1987 & grdhi>=17
}

if `yr'>=92 | `yr'<=13 {
gen edgroup=.

replace edgroup=1 if grdatn<=38
replace edgroup=2 if grdatn==39
replace edgroup=3 if grdatn>=40 & grdatn<=42
replace edgroup=4 if grdatn>=43
}

assert edgroup!=.

gen margroup=.

replace margroup=1 if marstat>=1 & marstat<=6 & year>=1988
replace margroup=1 if marstat>=1 & marstat<=7 & year<=1987
replace margroup=2 if marstat==7 & year>=1988
replace margroup=2 if marstat==8 & year<=1987

assert margroup!=.

if `yr'>=88 & `yr'<=94 {
gen indchange=(ind1950!=ind1950ly) if aindlyr==0 & aind==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1

gen occchange=(occ1950!=occ1950ly) if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1

gen empchange=(nuempl>=2 & nuempl<=3) if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1 & nuempl>=1
}

if `yr'>=96 | `yr'<=15 {
gen indchange=(ind1950!=ind1950ly) if aindlyr==0 & aind==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1

gen occchange=(occ1950!=occ1950ly) if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1

gen empchange=(nuempl>=2 & nuempl<=3) if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1 & nuempl>=1
}

if `yr'==95 {
gen indchange=(ind1950!=ind1950ly) if aindlyr==0 & aind==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1

gen occchange=(occ1950!=occ1950ly) if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1

gen empchange=(nuempl>=2 & nuempl<=3) if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1 & nuempl>=1
}

if `yr'>15 & `yr'<88 {
gen indchange=(ind1950!=ind1950ly) if aind==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0 

gen occchange=(occ1950!=occ1950ly) if aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0 

gen empchange=(nuempl>=2 & nuempl<=3) if aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & nuempl>=1
gen ravensamp=1
}
keep if age>=18
replace age=80 if age>=80
sort year sex age edgroup margroup indgrouply
gen n=wgt
collapse (mean) indchange occchange empchange (rawsum) n [aw=wgt], by(year sex age edgroup margroup indgrouply)
sort year sex age edgroup margroup indgroup
tempfile temp`yr'
save `temp`yr'', replace
}

use `tempipums', clear
append using `temp80'
foreach yr in  81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13 {
append using `temp`yr''
}
sort year sex age edgroup margroup indgrouply
save research/brookings-dynamism/dta/pub/jobchange-decomp.dta, replace




foreach yr in 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13 {

if `yr'!=88 {
use mcr/scratch-m1cls01/data/cps/inequality/mar`yr'.dta, clear
}

else {
use mcr/scratch-m1cls01/data/cps/inequality/mar88b.dta, clear
}

if `yr'>16 {
gen year=1900+`yr' 
}

if `yr'<=16 {
gen year=2000+`yr'
}

if `yr'<=91 & `yr'>15 {
gen edgroup=.

replace edgroup=1 if year>=1988 & year<=1991 & grdhi<12
replace edgroup=2 if year>=1988 & year<=1991 & grdhi==12
replace edgroup=3 if year>=1988 & year<=1991 & grdhi>=13 & grdhi<=15
replace edgroup=4 if year>=1988 & year<=1991 & grdhi>=16

replace edgroup=1 if year<=1987 & grdhi<13
replace edgroup=2 if year<=1987 & grdhi==13
replace edgroup=3 if year<=1987 & grdhi>=14 & grdhi<=16
replace edgroup=4 if year<=1987 & grdhi>=17
}

if `yr'>=92 | `yr'<=13 {
gen edgroup=.

replace edgroup=1 if grdatn<=38
replace edgroup=2 if grdatn==39
replace edgroup=3 if grdatn>=40 & grdatn<=42
replace edgroup=4 if grdatn>=43
}

gen margroup=.

replace margroup=1 if marstat>=1 & marstat<=6 & year>=1988
replace margroup=1 if marstat>=1 & marstat<=7 & year<=1987
replace margroup=2 if marstat==7 & year>=1988
replace margroup=2 if marstat==8 & year<=1987

assert margroup!=.


if `yr'>=88 & `yr'<=94 {
gen migstate=(migmtr3>=4 & migmtr3<=6) if suprec==1
}

if `yr'>=96 | `yr'<=15 {
gen migstate=(migmtr3>=4 & migmtr3<=6) if suprec==1 & amigsam==0 & amigmtr3==0 
}

if `yr'==95 {
gen migstate=.
}

if `yr'>15 & `yr'<88 {
gen migstate=(miggen==5 | miggen==6)
}
keep if age>=16
replace age=80 if  age>=80
sort year sex age edgroup margroup
collapse (mean) migstate [aw=wgt], by(year sex age edgroup margroup)

tempfile temp`yr'
save `temp`yr'', replace
}

use `temp81', clear
foreach yr in 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13 {
append using `temp`yr''
}
sort year sex age edgroup margroup
save research/brookings-dynamism/dta/pub/migrate-decomp.dta, replace


use research/brookings-dynamism/dta/data/jobchange-decomp.dta
merge year sex age edgroup margroup using research/brookings-dynamism/dta/pub/migrate-decomp.dta
drop _merge
sort year sex age edgroup margroup
save research/brookings-dynamism/dta/pub/jobchange-migrate-decomp.dta, replace


use research/brookings-dynamism/dta/pub/jobchange-migrate-decomp.dta, clear

foreach yr of numlist 1968/2013 {
gen yr`yr'=(year==`yr')
sum n if year==`yr'
replace n=n/`r(sum)' if year==`yr'
}

mat migstate=J(80,5,0)
mat indchange=J(80,6,0)
mat occchange=J(80,6,0)
mat empchange=J(80,6,0)

foreach v of varlist indchange occchange {
local i=1
foreach yr of numlist 1976/2013 {
mat `v'[`i',1]=`yr'
local ++i
}

xi: reg `v' yr1976-yr2013 [aw=n] if year>=1976, nocons
local i=1
foreach yr of numlist 1976/2013 {
mat `v'[`i',2]=_b[yr`yr']
local ++i
}

xi: reg `v' yr1976-yr2013 i.age i.sex [aw=n] if year>=1976, nocons
local i=1
foreach yr of numlist 1976/2013 {
mat `v'[`i',3]=_b[yr`yr']
local ++i
}

xi: reg `v' yr1976-yr2013 i.age i.sex i.margroup [aw=n] if year>=1976, nocons
local i=1
foreach yr of numlist 1976/2013 {
mat `v'[`i',4]=_b[yr`yr']
local ++i
}

xi: reg `v' yr1976-yr2013 i.age i.sex i.edgroup i.margroup [aw=n] if year>=1976, nocons
local i=1
foreach yr of numlist 1976/2013 {
mat `v'[`i',5]=_b[yr`yr']
local ++i
}

xi: reg `v' yr1976-yr2013 i.age i.sex i.edgroup i.margroup i.indgroup [aw=n] if year>=1976, nocons
local i=1
foreach yr of numlist 1976/2013 {
mat `v'[`i',6]=_b[yr`yr']
local ++i
}

}

foreach v of varlist empchange {
local i=1
foreach yr of numlist 1976/2013 {
mat `v'[`i',1]=`yr'
local ++i
}

xi: reg `v' yr1976-yr2013 [aw=n] if year>=1976, nocons
local i=1
foreach yr of numlist 1976/2013 {
mat `v'[`i',2]=_b[yr`yr']
local ++i
}

xi: reg `v' yr1976-yr2013 i.age i.sex [aw=n] if year>=1976, nocons
local i=1
foreach yr of numlist 1976/2013 {
mat `v'[`i',3]=_b[yr`yr']
local ++i
}

xi: reg `v' yr1976-yr2013 i.age i.sex i.margroup [aw=n] if year>=1976, nocons
local i=1
foreach yr of numlist 1976/2013 {
mat `v'[`i',4]=_b[yr`yr']
local ++i
}

xi: reg `v' yr1976-yr2013 i.age i.sex i.edgroup i.margroup [aw=n] if year>=1976, nocons
local i=1
foreach yr of numlist 1976/2013 {
mat `v'[`i',5]=_b[yr`yr']
local ++i
}

xi: reg `v' yr1976-yr2013 i.age i.sex i.edgroup i.margroup i.indgroup [aw=n] if year>=1976, nocons
local i=1
foreach yr of numlist 1976/2013 {
mat `v'[`i',6]=_b[yr`yr']
local ++i
}

}


foreach v of varlist migstate {
local i=1
foreach yr of numlist 1981/2013 {
mat `v'[`i',1]=`yr'
local ++i
}

xi: reg `v' yr1981-yr2013 [aw=n] if year>=1981, nocons
local i=1
foreach yr of numlist 1981/2013 {
mat `v'[`i',2]=_b[yr`yr']
local ++i
}

xi: reg `v' yr1981-yr2013 i.age i.sex [aw=n] if year>=1981, nocons
local i=1
foreach yr of numlist 1981/2013 {
mat `v'[`i',3]=_b[yr`yr']
local ++i
}

xi: reg `v' yr1981-yr2013 i.age i.sex i.margroup [aw=n] if year>=1981, nocons
local i=1
foreach yr of numlist 1981/2013 {
mat `v'[`i',4]=_b[yr`yr']
local ++i
}

xi: reg `v' yr1981-yr2013 i.age i.sex i.edgroup i.margroup [aw=n] if year>=1981, nocons
local i=1
foreach yr of numlist 1981/2013 {
mat `v'[`i',5]=_b[yr`yr']
local ++i
}

}

drop _all

foreach v in indchange occchange empchange {
drop _all
svmat `v'
rename `v'1 year
rename `v'2 yearFE
rename `v'3 and_agesex
rename `v'4 and_mar
rename `v'5 and_ed
rename `v'6 and_ind
drop if year==0
save research/brookings-dynamism/output/pub/`v'-decomp.dta, replace
}

foreach v in migstate {
drop _all
svmat `v'
rename `v'1 year
rename `v'2 yearFE
rename `v'3 and_agesex
rename `v'4 and_mar
rename `v'5 and_ed
drop if year==0
save research/brookings-dynamism/output/pub/`v'-decomp.dta, replace
}
