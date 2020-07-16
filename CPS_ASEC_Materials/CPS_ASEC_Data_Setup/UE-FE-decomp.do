set more off
clear

***Creates UE rates using matched CPS data 
***Uses this data to run cell-level regressions for the decomps shown in Fig 5 and fig A4
***Note: portion of the code that uses matched CPS data is derived from code on Rob Shimer's website

local x=197602
while `x' <= 201412 {
clear
local date="`x'"
if `x' != 197601 & `x' != 197801 & `x' != 198507 & `x' != 198510 & `x' != 199401 & `x' != 199506 & `x' != 199507 & `x' != 199508 & `x' != 199509 {

use mcr/scratch-m1cls01/data/cps/matching/merg`x', clear
capture drop _merge
keep if age >= 16
destring ind0, replace
drop ind1
rename ind0 ind
drop if ind==.
drop if mar1==.
drop if educ1==.

gen year=substr("`date'",1,4)
gen month=substr("`date'",5,2)
destring year, replace
destring month, replace

gen str1 lfs0 = "E" if status0 == 1 | status0 == 2
replace lfs0 = "U" if status0 == 3
replace lfs0 = "I" if status0 == 4 | status0 == 5 | status0 == 6 | status0 == 7
replace lfs0 = "U" if status0 == 4 & `x' > 198901
replace lfs0 = "M" if lfs0 == ""
gen str1 lfs1 = "E" if status1 == 1 | status1 == 2
replace lfs1 = "U" if status1 == 3
replace lfs1 = "I" if status1 == 4 | status1 == 5 | status1 == 6 | status1 == 7
replace lfs1 = "U" if status1 == 4 & `x' > 198900
replace lfs1 = "M" if lfs1 == ""

gen str2 lfs2 = lfs0 + lfs1

keep if lfs0=="U"
gen UE=lfs2=="UE"

gen edgroup=.

replace edgroup=1 if year>=1992 & educ1<=38
replace edgroup=2 if year>=1992 & educ1==39
replace edgroup=3 if year>=1992 & educ1>=40 & educ1<=42
replace edgroup=4 if year>=1992 & educ1>=43

replace edgroup=1 if year>=1989 & year<=1991 & educ1<12
replace edgroup=2 if year>=1989 & year<=1991 & educ1==12
replace edgroup=3 if year>=1989 & year<=1991 & educ1>=13 & educ1<=15
replace edgroup=4 if year>=1989 & year<=1991 & educ1>=16

replace edgroup=1 if year<=1988 & educ1<13
replace edgroup=2 if year<=1988 & educ1==13
replace edgroup=3 if year<=1988 & educ1>=14 & educ1<=16
replace edgroup=4 if year<=1988 & educ1>=17

assert edgroup!=.

gen margroup=.

replace margroup=1 if mar1>=1 & mar1<=4 & year<=1988
replace margroup=1 if mar1>=1 & mar1<=6 & year>=1989 & year<=1993
replace margroup=1 if mar1>=1 & mar1<=5 & year>=1994
replace margroup=2 if mar1==5 & year<=1988
replace margroup=2 if mar1==7 & year>=1989 & year<=1993
replace margroup=2 if mar1==6 & year>=1994

assert margroup!=.

gen wgt=fweight1

keep age sex edgroup margroup UE wgt year month

compress
save mcr/scratch-m1cls01/data/cps/UE-decomp-`x'.dta, replace
}

else {
clear
set obs 1
gen year=substr("`date'",1,4)
gen month=substr("`date'",5,2)
destring year, replace
destring month, replace

compress
save mcr/scratch-m1cls01/data/cps/UE-decomp-`x'.dta, replace
}

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
}
}


local x=197602
use mcr/scratch-m1cls01/data/cps/UE-decomp-`x'.dta, clear
while `x' <= 201412 {
append using mcr/scratch-m1cls01/data/cps/UE-decomp-`x'.dta
local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
}
}
replace age=80 if age>=80
sort year month age sex edgroup margroup 
gen n=wgt
collapse (mean) UE (rawsum) n [aw=wgt], by (year month age sex edgroup margroup)

foreach yr of numlist 1976/2014 {
gen yr`yr'=(year==`yr')
}

mat UE=J(40,5,0)
foreach v of varlist UE {
local i=1
foreach yr of numlist 1976/2014 {
mat `v'[`i',1]=`yr'
local ++i
}

xi: reg `v' yr1976-yr2014 i.month [aw=n], nocons
local i=1
foreach yr of numlist 1976/2014 {
mat `v'[`i',2]=_b[yr`yr']
local ++i
}

xi: reg `v' yr1976-yr2014 i.month i.age i.sex [aw=n], nocons
local i=1
foreach yr of numlist 1976/2014 {
mat `v'[`i',3]=_b[yr`yr']
local ++i
}

xi: reg `v' yr1976-yr2014 i.month i.age i.sex i.margroup [aw=n], nocons
local i=1
foreach yr of numlist 1976/2014 {
mat `v'[`i',4]=_b[yr`yr']
local ++i
}

xi: reg `v' yr1976-yr2014 i.month i.age i.sex i.edgroup i.margroup [aw=n], nocons
local i=1
foreach yr of numlist 1976/2014 {
mat `v'[`i',5]=_b[yr`yr']
local ++i
}

}

drop _all

svmat UE
rename UE1 year
rename UE2 yearFE
rename UE3 and_agesex
rename UE4 and_mar
rename UE5 and_ed

save research/brookings-dynamism/output/pub/UE-decomp.dta, replace
