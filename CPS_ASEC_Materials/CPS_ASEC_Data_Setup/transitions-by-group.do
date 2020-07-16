set more off
clear

local x=197602
use mcr/scratch-m1cls01/data/cps/starE-decomp-`x'.dta, clear
while `x' <= 201412 {
append using mcr/scratch-m1cls01/data/cps/starE-decomp-`x'.dta
local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
}
}
replace age=80 if age>=80

gen agegroup=1 if age>=16 & age<=24
replace agegroup=2 if age>=25 & age<=54
replace agegroup=3 if age>=55

gen n=wgt
gen count=n
preserve
gen status="16-24" if agegroup==1
replace status="25-54" if agegroup==2
replace status="55+" if agegroup==3
keep if status!=""
sort year status
collapse (mean) starE (rawsum) count  [aw=wgt], by (year status)
tempfile t1
save `t1', replace
restore
preserve

keep if age>=25 & age<=54
gen status="male" if sex==1
replace status="female" if sex==2

sort year status

collapse (mean) starE (rawsum) count [aw=wgt], by (year status)
tempfile t2
save `t2', replace
restore

gen status="all" 
sort year status
collapse (mean) starE (rawsum) count  [aw=wgt], by (year status)

append using `t1'
append using `t2'
sort year status
save research/brookings-dynamism/dta/pub/starE-by-groups.dta, replace

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

gen agegroup=1 if age>=16 & age<=24
replace agegroup=2 if age>=25 & age<=54
replace agegroup=3 if age>=55

gen n=wgt
gen count=n
preserve
gen status="16-24" if agegroup==1
replace status="25-54" if agegroup==2
replace status="55+" if agegroup==3
keep if status!=""
sort year status
collapse (mean) UE (rawsum) count  [aw=wgt], by (year status)
tempfile t1
save `t1', replace
restore
preserve

keep if age>=25 & age<=54
gen status="male" if sex==1
replace status="female" if sex==2

sort year status

collapse (mean) UE (rawsum) count [aw=wgt], by (year status)
tempfile t2
save `t2', replace
restore

gen status="all" 
sort year status
collapse (mean) UE (rawsum) count  [aw=wgt], by (year status)

append using `t1'
append using `t2'
sort year status
save research/brookings-dynamism/dta/pub/UE-by-groups.dta, replace

local x=197602
use mcr/scratch-m1cls01/data/cps/NE-decomp-`x'.dta, clear
while `x' <= 201412 {
append using mcr/scratch-m1cls01/data/cps/NE-decomp-`x'.dta
local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
}
}
replace age=80 if age>=80

gen agegroup=1 if age>=16 & age<=24
replace agegroup=2 if age>=25 & age<=54
replace agegroup=3 if age>=55

gen n=wgt
gen count=n
preserve
gen status="16-24" if agegroup==1
replace status="25-54" if agegroup==2
replace status="55+" if agegroup==3
keep if status!=""
sort year status
collapse (mean) NE (rawsum) count  [aw=wgt], by (year status)
tempfile t1
save `t1', replace
restore
preserve

keep if age>=25 & age<=54
gen status="male" if sex==1
replace status="female" if sex==2

sort year status

collapse (mean) NE (rawsum) count [aw=wgt], by (year status)
tempfile t2
save `t2', replace
restore

gen status="all" 
sort year status
collapse (mean) NE (rawsum) count  [aw=wgt], by (year status)

append using `t1'
append using `t2'
sort year status
save research/brookings-dynamism/dta/pub/NE-by-groups.dta, replace



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

gen agegroup=1 if age>=16 & age<=24
replace agegroup=2 if age>=25 & age<=54
replace agegroup=3 if age>=55

gen n=wgt

gen count=n
preserve
gen status="16-24" if agegroup==1
replace status="25-54" if agegroup==2
replace status="55+" if agegroup==3
keep if status!=""
sort year status
collapse (mean) Estar EN EU (rawsum) count  [aw=wgt], by (year status)
tempfile t1
save `t1', replace
restore
preserve

keep if age>=25 & age<=54
gen status="male" if sex==1
replace status="female" if sex==2

sort year status
collapse (mean) Estar EN EU (rawsum) count  [aw=wgt], by (year status)
tempfile t2
save `t2', replace
restore

gen status="all" 
sort year status
collapse (mean) Estar EN EU (rawsum) n (rawsum) count  [aw=wgt], by (year status)

append using `t1'
append using `t2'
sort year status

save research/brookings-dynamism/dta/pub/Estar-by-groups.dta, replace

use research/brookings-dynamism/dta/pub/jobchange-migrate-decomp.dta, replace

gen agegroup=1 if age>=16 & age<=24
replace agegroup=2 if age>=25 & age<=54
replace agegroup=3 if age>=55

gen count=n

preserve
gen status="16-24" if agegroup==1
replace status="25-54" if agegroup==2
replace status="55+" if agegroup==3
keep if status!=""
sort year status
collapse (mean) indchange occchange empchange migstate (rawsum) count [aw=n], by (year status)
tempfile t1
save `t1', replace
restore
preserve

keep if age>=25 & age<=54
gen status="male" if sex==1
replace status="female" if sex==2

sort year status
collapse (mean) indchange occchange empchange migstate (rawsum) count [aw=n], by (year status)
tempfile t2
save `t2', replace
restore

gen status="all" 
sort year status
collapse (mean) indchange occchange empchange migstate (rawsum) count [aw=n], by (year status)

append using `t1'
append using `t2'
sort year status

sort year status
save research/brookings-dynamism/dta/pub/jobmigrate-by-groups.dta, replace

use research/brookings-dynamism/dta/pub/starE-by-groups.dta
sort year status 
merge year status using research/brookings-dynamism/dta/pub/UE-by-groups.dta
drop _merge
sort year status 
merge year status using research/brookings-dynamism/dta/pub/NE-by-groups.dta
drop _merge
sort year status 
merge year status  using research/brookings-dynamism/dta/pub/Estar-by-groups.dta
drop _merge
sort year status  
merge year status  using research/brookings-dynamism/dta/pub/jobmigrate-by-groups
drop _merge
sort year status  
save research/brookings-dynamism/output/pub/transitions-by-groups, replace


