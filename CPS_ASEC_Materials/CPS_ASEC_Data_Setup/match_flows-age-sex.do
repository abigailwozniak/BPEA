local x=197601
*local x=201404
while `x' <= 201508 {

quietly {
if `x' != 197601 & `x' != 197801 & `x' != 198507 & `x' != 198510 & `x' != 199401 & `x' != 199506 & `x' != 199507 & `x' != 199508 & `x' != 199509 {

use mcr/scratch-m1cls01/data/cps/matching/merg`x', clear
keep if age >= 16 & age!=.
replace age=80 if age>=80

* drop if mis0 == 1

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
drop state0
rename state1 state
drop if state==.
sort age sex lfs2
replace fweight0 = 0 if fweight0 == .
replace fweight1 = 0 if fweight1 == .
gen weight = (fweight0+fweight1)/2
egen double flows = sum(weight), by(age lfs2)
replace flows = flows/1000
if `x' > 199400 {
	replace flows = flows/100
}

sort age sex lfs2
quietly by age sex lfs2:  gen duplic = cond(_N==1,0,_n)
drop if duplic > 1
keep lfs2 flows age sex

sort age sex lfs2
collapse (sum) flows, by(age sex lfs2)
gen date = `x'

reshape wide flows, i(date age sex) j(lfs2) string


capture gen flowsEM = .
capture gen flowsUM = .
capture gen flowsIM = .
capture gen flowsME = .
capture gen flowsMI = .
capture gen flowsMU = .

foreach var of varlist flowsEE flowsEI flowsEU flowsEM flowsUU flowsUI flowsUE flowsUM flowsII flowsIU flowsIE flowsIM flowsMU flowsMI flowsME {
replace `var'=0 if `var'==.
}

gen flowEE = flowsEE/(flowsEE+flowsEI+flowsEU+flowsEM)
gen flowEI = flowsEI/(flowsEE+flowsEI+flowsEU+flowsEM)
gen flowEU = flowsEU/(flowsEE+flowsEI+flowsEU+flowsEM)
gen flowEM = flowsEM/(flowsEE+flowsEI+flowsEU+flowsEM)
gen flowUE = flowsUE/(flowsUE+flowsUI+flowsUU+flowsUM)
gen flowUI = flowsUI/(flowsUE+flowsUI+flowsUU+flowsUM)
gen flowUU = flowsUU/(flowsUE+flowsUI+flowsUU+flowsUM)
gen flowUM = flowsUM/(flowsUE+flowsUI+flowsUU+flowsUM)
gen flowIE = flowsIE/(flowsIE+flowsII+flowsIU+flowsIM)
gen flowII = flowsII/(flowsIE+flowsII+flowsIU+flowsIM)
gen flowIU = flowsIU/(flowsIE+flowsII+flowsIU+flowsIM)
gen flowIM = flowsIM/(flowsIE+flowsII+flowsIU+flowsIM)
gen flowME = flowsME/(flowsME+flowsMI+flowsMU)
gen flowMI = flowsMI/(flowsME+flowsMI+flowsMU)
gen flowMU = flowsMU/(flowsME+flowsMI+flowsMU)

gen e=0
foreach var of varlist flowsEE flowsEI flowsEU flowsEM {
replace e=e+`var'
}

gen u=0
foreach var of varlist flowsUE flowsUI flowsUU flowsUM {
replace u=u+`var'
}

gen n=0
foreach var of varlist flowsIE flowsII flowsIU flowsIM {
replace n=n+`var'
}

gen m=0
foreach var of varlist flowsME flowsMI flowsMU {
replace m=m+`var'
}

gen e1=0
foreach var of varlist flowsEE flowsIE flowsUE flowsME {
replace e1=e1+`var'
}

gen u1=0
foreach var of varlist flowsEU flowsIU flowsUU flowsMU {
replace u1=u1+`var'
}

gen n1=0
foreach var of varlist flowsEI flowsII flowsUI flowsMI {
replace n1=n1+`var'
}

gen m1=0
foreach var of varlist flowsEM flowsIM flowsUM {
replace m1=m1+`var'
}

drop flows*

}

else {
clear
set obs 1
gen date = `x'
gen flowEE = .
gen flowEI = .
gen flowEU = .
gen flowEM = .
gen flowUE = .
gen flowUU = .
gen flowUI = .
gen flowUM = .
gen flowIE = .
gen flowIU = .
gen flowII = .
gen flowIM = .
gen flowME = .
gen flowMU = .
gen flowMI = .
gen e=.
gen u=.
gen n=.
gen m=.
gen e1=.
gen u1=.
gen n1=.
gen m1=.
}


if `x' >= 197602 {
*if `x' >= 201404 {
    append using research/brookings-dynamism/dta/pub/flows-age-sex
}
    
save "research/brookings-dynamism/dta/pub/flows-age-sex.dta", replace
}
 
local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
}
}

sort date

gen flowMM = 0

preserve
save "research/brookings-dynamism/dta/pub/flows-age-sex.dta", replace

gen tmp=string(date)
gen year=substr(tmp,1,4)
gen month=substr(tmp,2,5)
drop tmp
destring year, replace
destring month, replace

rename flowUI flowUN
rename flowIE flowNE
rename flowIU flowNU
rename flowII flowNN
rename flowEI flowEN

drop flowUM flowEM flowIM flowMI flowMU flowMM flowME

drop if year==2015
sort year month age sex
save "research/brookings-dynamism/dta/pub/flows-age-sex.dta", replace

restore
sort year age sex
collapse flowEE-flowNU e u n m e1 u1 n1 m1, by(year age sex)
sort year age sex

rename flowEE ee
rename flowEN en
rename flowEU eu
rename flowUE ue
rename flowUN un
rename flowUU uu
rename flowNE ne
rename flowNN nn
rename flowNU nu

sort year age sex
save "research/brookings-dynamism/dta/pub/flows-annual-age-sex.dta", replace
