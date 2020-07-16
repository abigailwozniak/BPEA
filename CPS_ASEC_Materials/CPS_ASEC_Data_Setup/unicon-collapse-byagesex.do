set more off
capture log close


foreach yr in 76 77 78 79 80 {

use mcr/scratch-m1cls01/data/cps/brookings-dynamism/weight/mar`yr'.dta, clear
sort recnum
tempfile temp
save `temp', replace

use mcr/scratch-m1cls01/data/cps/brookings-dynamism/dynam/mar`yr'.dta, clear
sort recnum
merge recnum using `temp'
drop _merge
drop if wgt<=0

replace age=80 if age>=80
gen year=1900+`yr'

gen empchange=(nuempl>=2 & nuempl<=3) if wksly>0 & occ>0 & ind>0 & occly>0 & indly>0 & nuempl>=1

keep if age>=18
sort year age sex
gen n=wgt if wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  
collapse (mean) empchange (rawsum) n [aw=wgt], by(year age sex)

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
replace age=80 if age>=80


if `yr'>=88 & `yr'<=94 {

gen empchange=(nuempl>=2 & nuempl<=3) if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1 & nuempl>=1
gen migstate=(migmtr3>=4 & migmtr3<=6) if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1
gen n=wgt if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1 
}

if `yr'>=96 | `yr'<=15 {


gen empchange=(nuempl>=2 & nuempl<=3) if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1 & nuempl>=1

gen migstate=(migmtr3>=4 & migmtr3<=6) if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1 & amigsam==0 & amigmtr3==0
gen n=wgt if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1
}

if `yr'==95 {

gen empchange=(nuempl>=2 & nuempl<=3) if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1 & nuempl>=1

gen migstate=.
gen n=wgt if aocclyr==0 & aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & suprec==1
}

if `yr'>15 & `yr'<88 {

gen empchange=(nuempl>=2 & nuempl<=3) if aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  & nuempl>=1
gen migstate=.
gen n=wgt  if aocc==0 & wksly>0 & occ>0 & ind>0 & occly>0 & indly>0  

}
keep if age>=18
sort year age sex
collapse (mean) empchange migstate (rawsum) n [aw=wgt], by(year age sex)

tempfile temp`yr'
save `temp`yr'', replace
}

use `temp76', clear
foreach yr in 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13 {
append using `temp`yr''
}
sort year age sex
save research/brookings-dynamism/dta/pub/unicon-collapse-byagesex.dta, replace

