***uses industry/occupation crosswalk files occ1950-crosswalk.dta and ind1950-crosswalk.dta


set more off
capture log close


foreach yr in 76 77 78 79 80 {

gen empchange=(nuempl>=2 & nuempl<=3) if wksly>0 & occ>0 & ind>0 & occly>0 & indly>0 & nuempl>=1

keep if age>=18
sort year
collapse (mean) empchange [aw=wgt], by(year)

tempfile temp`yr'
save `temp`yr'', replace
}

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

if `yr'>=88 & `yr'<=94 {

gen empchange=(nuempl>=2 & nuempl<=3) if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1 & nuempl>=1
}

if `yr'>=96 | `yr'<=15 {

gen empchange=(nuempl>=2 & nuempl<=3) if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1 & nuempl>=1
}

if `yr'==95 {

gen empchange=(nuempl>=2 & nuempl<=3) if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1 & nuempl>=1
}

if `yr'>15 & `yr'<88 {

gen empchange=(nuempl>=2 & nuempl<=3) if aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & nuempl>=1
}
keep if age>=18
sort year
collapse (mean) empchange [aw=wgt], by(year)

tempfile temp`yr'
save `temp`yr'', replace
}

use `temp76', clear
foreach yr in 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13 {
append using `temp`yr''
}
sort year
save research/brookings-dynamism/dta/data/unicon-collapse.dta, replace

foreach yr in 68 69 70 {

use mcr/scratch-m1cls01/data/cps/brookings-dynamism/weight/mar`yr'.dta, clear
sort recnum
tempfile temp
save `temp', replace

use mcr/scratch-m1cls01/data/cps/brookings-dynamism/dynam/mar`yr'.dta, clear
sort recnum
merge recnum using `temp'
drop _merge
drop if wgt<=0

gen year=1900+`yr'

if `yr'>=68 & `yr'<=71 {
gen migstate=(miggen>=4 & miggen<=7)
}

gen ravensamp=1
keep if age>=16
sort year
collapse (mean) migstate [aw=wgt], by(year)

tempfile temp`yr'
save `temp`yr'', replace
}

foreach yr in 71 72 73 74 75 76  {

use mcr/scratch-m1cls01/data/cps/brookings-dynamism/weight/mar`yr'.dta, clear
sort recnum
tempfile temp
save `temp', replace

use mcr/scratch-m1cls01/data/cps/brookings-dynamism/dynam/mar`yr'.dta, clear
sort recnum
merge recnum using `temp'
drop _merge
drop if wgt<=0

gen year=1900+`yr'


if `yr'==71 {
gen migstate=(miggen==4 | miggen==5 | miggen==6 | miggen==7)
}

if `yr'==76 {
gen migstate=(miggen==5 | miggen==6 | miggen==7)
}

if `yr'>=77 {
gen migstate=(miggen==5 | miggen==6)
}

if `yr'>=72 & `yr'<=75 {
gen migstate=.
}

gen ravensamp=1
keep if age>=16
sort year
collapse (mean) migstate [aw=wgt], by(year)

tempfile temp`yr'
save `temp`yr'', replace
}

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


if `yr'>=88 & `yr'<=94 {
gen ravensamp=(suprec==1)
gen migstate=(migmtr3>=4 & migmtr3<=6) if suprec==1
}

if `yr'>=96 | `yr'<=15 {
gen ravensamp=(suprec==1 & amigsam==0 & amigmtr3==0)
gen migstate=(migmtr3>=4 & migmtr3<=6) if suprec==1 & amigsam==0 & amigmtr3==0 
}

if `yr'==95 {
gen ravensamp=(suprec==1 & amigsam==0 & amigmtr3==0)
gen migstate=.
}

if `yr'>15 & `yr'<88 {
gen migstate=(miggen==5 | miggen==6)
gen ravensamp=1
}
keep if age>=16
sort year
collapse (mean) migstate [aw=wgt], by(year)

tempfile temp`yr'
save `temp`yr'', replace
}

use `temp68', clear
foreach yr in 69 70 71 72 73 74 75 76 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13 {
append using `temp`yr''
}
sort year
save research/brookings-dynamism/dta/data/unicon-collapse-migrate.dta, replace

use research/brookings-dynamism/dta/data/unicon-collapse.dta
merge year using research/brookings-dynamism/dta/data/unicon-collapse-migrate.dta
drop _merge
sort year
save, replace
