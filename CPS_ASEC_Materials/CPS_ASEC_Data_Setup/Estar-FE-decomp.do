set more off
clear

***Creates E* rates using matched CPS data 
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

keep if lfs0=="E"
gen EU=lfs2=="EU"
gen EN=lfs2=="EI"
gen Estar=(EU==1 | EN==1)

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

sort year ind
merge year ind using research/brookings-dynamism/dta/ind1950-crosswalk.dta, keep(indgroup ind1950)
keep if _merge==3
drop if indgroup==.
drop _merge

gen wgt=fweight1

keep age sex edgroup margroup indgroup EU EN wgt year month Estar

compress
save mcr/scratch-m1cls01/data/cps/Estar-decomp-`x'.dta, replace
}

else {
clear
set obs 1
gen year=substr("`date'",1,4)
gen month=substr("`date'",5,2)
destring year, replace
destring month, replace

compress
save mcr/scratch-m1cls01/data/cps/Estar-decomp-`x'.dta, replace
}

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
}
}


local x=197602
use mcr/scratch-m1cls01/data/cps/Estar-decomp-`x'.dta, clear
while `x' <= 201412 {
append using mcr/scratch-m1cls01/data/cps/Estar-decomp-`x'.dta
local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
}
}

replace age=80 if age>=80
sort year month age sex edgroup margroup indgroup 
gen n=wgt
collapse (mean) EU EN Estar (rawsum) n [aw=wgt], by (year month age sex edgroup margroup indgroup)

foreach yr of numlist 1976/2014 {
gen yr`yr'=(year==`yr')
sum n if year==`yr'
replace n=n/`r(sum)' if year==`yr'
}



mat EU=J(40,6,0)
mat EN=J(40,6,0)
mat Estar=J(40,6,0)
foreach v of varlist EU EN Estar {
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

xi: reg `v' yr1976-yr2014 i.month i.age i.sex i.edgroup i.margroup i.indgroup [aw=n], nocons
local i=1
foreach yr of numlist 1976/2014 {
mat `v'[`i',6]=_b[yr`yr']
local ++i
}

}

drop _all

svmat EU
rename EU1 year
rename EU2 yearFE
rename EU3 and_agesex
rename EU4 and_mar
rename EU5 and_ed
rename EU6 and_ind

save research/brookings-dynamism/output/pub/EU-decomp.dta, replace

drop _all
svmat EN
rename EN1 year
rename EN2 yearFE
rename EN3 and_agesex
rename EN4 and_mar
rename EN5 and_ed
rename EN6 and_ind
save research/brookings-dynamism/output/pub/EN-decomp.dta, replace

drop _all
svmat Estar
rename Estar1 year
rename Estar2 yearFE
rename Estar3 and_agesex
rename Estar4 and_mar
rename Estar5 and_ed
rename Estar6 and_ind
save research/brookings-dynamism/output/pub/Estar-decomp.dta, replace



