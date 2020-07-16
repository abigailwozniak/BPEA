***For generating figures 5 and A4.  Uses data `v'-decomp, created by `v'-FE-decomp, where `v' is starE, Estar, UE, NE, migstate, empchange

set more off
clear
graph drop _all

cd "\\tsclient\G\research\brookings-dynamism\output\pub\"
foreach v in empchange  {
use `v'-decomp.dta, clear
foreach var of varlist yearFE and_agesex and_mar and_ed and_ind {
rename `var' `v'_`var'
}
sort year
tempfile temp`v'
save `temp`v'', replace
}

foreach v in migstate {
use `v'-decomp.dta, clear
foreach var of varlist yearFE and_agesex and_mar and_ed {
rename `var' `v'_`var'
}
sort year
tempfile temp`v'
save `temp`v'', replace
}

foreach v in UE NE starE {
use `v'-decomp.dta, clear
foreach var of varlist yearFE and_agesex and_mar and_ed {
rename `var' `v'_`var'
}
sort year
tempfile temp`v'
save `temp`v'', replace
}

foreach v in EU EN Estar {
use `v'-decomp.dta, clear
foreach var in yearFE and_agesex and_mar and_ed and_ind {
rename `var' `v'_`var'
}
sort year
tempfile temp`v'
save `temp`v'', replace
}

use `tempempchange', clear
foreach v in migstate UE NE EU EN Estar starE {
merge year using `temp`v''
drop _merge
sort year
}
drop if year==0
sort year

foreach v in migstate {
foreach var in yearFE and_agesex and_mar and_ed  {
sum `v'_`var' if year==1981
gen d_`v'_`var'=`v'_`var'-`r(sum)'
}
}

foreach v in UE NE starE {
foreach var in yearFE and_agesex and_mar and_ed  {
sum `v'_`var' if year==1976
gen d_`v'_`var'=`v'_`var'-`r(sum)'
}
}

foreach v in EU EN empchange Estar {
foreach var in yearFE and_agesex and_mar and_ed and_ind {
sum `v'_`var' if year==1976
gen d_`v'_`var'=`v'_`var'-`r(sum)'
}
}



foreach v in migstate {
if "`v'"=="migstate" local title="Fract. changing states"
# delimit ;
twoway 
(connected d_`v'_yearFE year if year!=1985 & year!=1995 & year>=1981, lcolor(black) lwidth(medthick) lpattern(solid) msymbol(none) msize(small) mcolor(black))
(connected d_`v'_and_mar year if year!=1985 & year!=1995 & year>=1981, lcolor(orange) lwidth(medthick) lpattern(solid) msymbol(X) msize(small) mcolor(orange))
(connected d_`v'_and_ed year if year!=1985 & year!=1995 & year>=1981, lcolor(navy) lwidth(medthick) lpattern(dash) msymbol(none) msize(small) mcolor(navy)),
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small)) 
plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small))

legend(order (1 "Year FE" 2 "Age, sex, and mar. status" 3 "Also controlling for ed." ) rows(2) size(vsmall) region(style(none)))
xlabel(1975(5)2015, labsize(vsmall)) 
xmlabel(1975(1)2015, nolab)
yline(0, lwidth(thin) lcolor(red))
xtitle("")
ytitle("")
ylabel(, nogrid labsize(vsmall))
title("`title'", size(small))
saving("decomp-`v'.gph", replace)
name(`v', replace);

graph export "decomp-`v'.pdf", as(pdf) replace;
# delimit cr
}

foreach v in empchange EU EN Estar UE NE starE {
if "`v'"=="empchange" local title="Fract. of emp. with 2+ employers"
if "`v'"=="Estar" local title="Monthly trans. rate from emp. to non-emp."
if "`v'"=="EU" local title="EU transition rate"
if "`v'"=="EN" local title="EN transition rate"
if "`v'"=="UE" local title="UE transition rate"
if "`v'"=="NE" local title="NE transition rate"
if "`v'"=="starE" local title="Monthly trans. rate from non-emp. to emp."
# delimit ;
twoway 
(connected d_`v'_yearFE year, lcolor(black) lwidth(medthick) lpattern(solid) msymbol(none) msize(small) mcolor(black))
(connected d_`v'_and_mar year, lcolor(orange) lwidth(medthick) lpattern(solid) msymbol(X) msize(small) mcolor(orange))
(connected d_`v'_and_ed year, lcolor(navy) lwidth(medthick) lpattern(dash) msymbol(none) msize(small) mcolor(navy)),
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small)) 
plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small))

legend(order (1 "Year FE" 2 "Age, sex, and mar. status" 3 "Also controlling for ed." ) rows(2) size(vsmall) region(style(none)))
xlabel(1975(5)2015, labsize(vsmall)) 
xmlabel(1975(1)2015, nolab)
yline(0, lwidth(thin) lcolor(red))
xtitle("")
ytitle("")
ylabel(, nogrid labsize(vsmall))
title("`title'", size(small))
saving("decomp-`v'.gph", replace)
name(`v', replace);

graph export "decomp-`v'.pdf", as(pdf) replace;
# delimit cr
}

cd "\\tsclient\G\research\brookings-dynamism\"
# delimit ;
graph combine Estar starE empchange migstate,
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small)) 
plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small))
note("Figures plot year fixed effects from regressions with listed controls.  All fixed effects are normalized to 0 for earliest value in sample.", size(vsmall))
name(decomps, replace);

graph combine EU EN UE NE,
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small)) 
plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small))
note("Figures plot year fixed effects from regressions with listed controls.  All fixed effects are normalized to 0 for earliest value in sample.", size(vsmall))
name(decomps2, replace);
# delimit cr

***for creating row 4 of table A1

mat A1=J(2,8,0)
mat A2=J(2,8,0)
local j=1
foreach var of varlist EN EU UE NE empchange migstate {
sum yearFE_`var' if year>=1981 & year<=1985
local y1=`r(mean)'

sum yearFE_`var' if year>=2010 & year<=2014
local y2=`r(mean)'

local diff=`y1'-`y2'

mat A1[1,`j']=`diff'

sum and_agesex_`var' if year>=1981 & year<=1985
local y1=`r(mean)'

sum and_agesex_`var' if year>=2010 & year<=2014
local y2=`r(mean)'

local diff=`y1'-`y2'

mat A1[2,`j']=`diff'
local ++j
}

local j=1
foreach var of varlist EN EU UE NE empchange migstate {
sum yearFE_`var' if year>=1991 & year<=1995
local y1=`r(mean)'

sum yearFE_`var' if year>=2010 & year<=2014
local y2=`r(mean)'

local diff=`y1'-`y2'

mat A2[1,`j']=`diff'

sum and_agesex_`var' if year>=1991 & year<=1995
local y1=`r(mean)'

sum and_agesex_`var' if year>=2010 & year<=2014
local y2=`r(mean)'

local diff=`y1'-`y2'

mat A2[2,`j']=`diff'
local ++j
}

drop _all
svmat A1
save "\\tsclient\G\research\brookings-dynamism\output\pub\age-decomp-E.dta", replace

drop _all
svmat A2
save "\\tsclient\G\research\brookings-dynamism\output\pub\age-decomp-F.dta", replace
