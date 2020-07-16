***For generating figures A1.  Uses data from multiple sources:
***EE-fleischman-fallick is EE transition rate as provided by the Federal Reserve website for Fleischman and Fallick 2004
***pop-stocks is the level of employment as provided by the BLS
***jolts is jolts data as provided by the BLS
***flows-monthly is monthly flows data as created by flows-monthly.do
***j2jqwi is J2J flows from the QWI
***unicon-collapse is migration and firm changing rates from unicon data, as created by unicon-collapse

clear
graph drop _all

use "\\tsclient\G\research\brookings-dynamism\dta\data\EE-fleischman-fallick.dta", clear
rename month m
sort year m
tempfile temp
save `temp', replace

use "\\tsclient\G\research\brookings-dynamism\dta\data\pop-stocks.dta", clear
sort year m
merge year m using "\\tsclient\G\research\brookings-dynamism\dta\jolts.dta"
drop _merge
sort year m
merge year m using `temp'
replace m=3 if m==1 | m==2
replace m=6 if m==4 | m==5
replace m=9 if m==7 | m==8
replace m=12 if m==10 | m==11

sort year m
collapse (mean) e u pop hires separations quits layoffs eehaz, by(year m)
sort year m
merge year m using "\\tsclient\G\research\brookings-dynamism\dta\flows-monthly.dta"

gen n=pop-e-u

gen jobfinding=((ue*u)+(ne*n))/e
gen jobsep=(eu+en)
replace ue=(ue*u)/e
replace ne=(ne*n)/e
replace eu=eu
replace en=en
replace hires=hires/100
replace separations=separations/100
replace quits=quits/100
replace layoffs=layoffs/100
keep if year>=1976
sort year m
gen t=_n
drop if year>=2016
# delimit ;
twoway 
(connected jobfind t, lcolor(maroon) lwidth(medthick) lpattern(solid) msymbol(none) msize(small) mcolor(maroon))
(connected hires t, lcolor(navy) lwidth(medthick) lpattern(dot) msymbol(none) msize(small) mcolor(navy))
(connected ue t, lcolor(maroon) lwidth(medthick) lpattern(dash) msymbol(none) msize(small) mcolor(maroon))
(connected ne t, lcolor(maroon) lwidth(medthick) lpattern(shortdash) msymbol(none) msize(small) mcolor(maroon))
,
legend(order (1 "CPS job finding rate" 2 "JOLTS hiring rate" 3 "UE rate" 4 "NE rate" ) rows(2) size(vsmall) region(style(none)))
xlabel(1 "1976" 17 "1980" 37 "1985" 57 "1990" 77 "1995" 97 "2000" 117 "2005" 137 "2010" 157 "2015", labsize(vsmall)) 
xmlabel(1(4)160, nolab)
xtitle("")
ytitle("")
ylabel(0 .03 .06 .09 .12, nogrid labsize(vsmall))
ymlabel(0(.015).12, nogrid nolabels)
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small)) 
plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small))
title("A. Job finding rate / hiring rate", size(small))
saving("\\tsclient\G\research\brookings-dynamism\output\pub\jobfind-hire.gph", replace)
name(hire, replace);

twoway 
(connected jobsep t, lcolor(maroon) lwidth(medthick) lpattern(solid) msymbol(none) msize(small) mcolor(maroon))
(connected separations t, lcolor(navy) lwidth(medthick) lpattern(dash) msymbol(none) msize(small) mcolor(navy))
,
legend(order (1 "CPS job separation rate" 2 "JOLTS separation rate" ) rows(2) size(vsmall) region(style(none)))
xlabel(1 "1976" 17 "1980" 37 "1985" 57 "1990" 77 "1995" 97 "2000" 117 "2005" 137 "2010" 157 "2015", labsize(vsmall)) 
xmlabel(1(4)160, nolab)
xtitle("")
ytitle("")
ylabel(.02(.01).06, nogrid labsize(vsmall))
ymlabel(.02(0.005).06, nogrid nolabels)
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small)) 
plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small))
title("B. Job separation rate", size(small))
saving("\\tsclient\G\research\brookings-dynamism\output\pub\jobsep1.gph", replace)
name(seps1, replace);

twoway 
(connected en t, lcolor(maroon) lwidth(medthick) lpattern(dot) msymbol(none) msize(small) mcolor(maroon))
(connected eu t, lcolor(maroon) lwidth(medthick) lpattern(shortdash) msymbol(none) msize(small) mcolor(maroon))
(connected quits t, lcolor(navy) lwidth(medthick) lpattern(dash) msymbol(none) msize(small) mcolor(navy))
(connected layoffs t, lcolor(navy) lwidth(medthick) lpattern(solid) msymbol(none) msize(small) mcolor(navy))
,
legend(order (1 "EN rate" 2 "EU rate" 3 "JOLTS quit rate" 4 "JOLTS layoff rate") rows(2) size(vsmall) region(style(none)))
xlabel(1 "1976" 17 "1980" 37 "1985" 57 "1990" 77 "1995" 97 "2000" 117 "2005" 137 "2010" 157 "2015", labsize(vsmall)) 
xmlabel(1(4)160, nolab)
xtitle("")
ytitle("")
ylabel(0(.01).04, nogrid labsize(vsmall))
ymlabel(0(.005).04, nogrid nolabels)
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small)) 
plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small))
title("C. Components of the job separation rate", size(small))
saving("\\tsclient\G\research\brookings-dynamism\output\pub\jobsep2.gph", replace)
name(seps2, replace);
# delimit cr

use "\\tsclient\G\research\brookings-dynamism\dta\data\EE-fleischman-fallick.dta", clear
sort year 
collapse (mean) eehaz, by(year)
tempfile temp
save `temp', replace

use "\\tsclient\G\research\brookings-dynamism\dta\data\unicon-collapse.dta", clear
keep year empchange
replace year=year-1
sort year
merge year using `temp'
drop _merge
sort year
merge year using "\\tsclient\G\research\brookings-dynamism\dta\data\j2jqwi.dta"
replace eehaz=eehaz*12/100
keep if year>=1976

# delimit ;

twoway 
(connected empchange year, lcolor(maroon) lwidth(medthick) lpattern(solid) msymbol(none) msize(small) mcolor(maroon) yaxis(1))
(connected j2jsepr year, lcolor(orange) lwidth(medthick) lpattern(dot) msymbol(none) msize(small) mcolor(navy) yaxis(1))
(connected eehaz year, lcolor(navy) lwidth(medthick) lpattern(dash) msymbol(none) msize(small) mcolor(maroon) yaxis(2))
,
legend(order (1 "Prev. year (March CPS), LHS" 2 "Prev. year (QWI), LHS" 3 "Prev. month (monthly CPS) multiplied by 12, RHS" ) rows(2) size(vsmall) region(style(none)))
xlabel(1976 1980 1985 1990 1995 2000 2005 2010 2015, labsize(vsmall)) 
xmlabel(1976(1)2015, nolab)
xtitle("")
ytitle("", axis(1))
ytitle("", axis(2))
ylabel(0(0.05).2, nogrid labsize(vsmall) axis(1))
ymlabel(0(.025).2, nogrid nolabels axis(1))
ylabel(0.05(0.1).45, nogrid labsize(vsmall) axis(2))
ymlabel(0.05(.05).45, nogrid nolabels axis(2))

graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small)) 
plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small))
title("D. Fract. changing jobs in prev. year or month", size(small))
saving("\\tsclient\G\research\brookings-dynamism\output\pub\j2j.gph", replace)
name(j2j, replace);

graph combine hire seps1 seps2 j2j,
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small)) 
plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small))
title("Figure A.X: Comparison of measures of labor market fluidity", size(small))
note("Source: JOLTS, Bureau of Labor Statistics.  CPS measures, see note to figure 1. For employer change (year), authors' calculations. For employer change (month), Fallick and Fleischman (2004)", size(tiny))
saving("\\tsclient\G\research\brookings-dynamism\output\pub\fluidity-compare.gph", replace)
name(fluidity, replace);

graph export "\\tsclient\G\research\brookings-dynamism\output\pub\fluidity-compare.pdf", as(pdf) replace;
# delimit cr
 


