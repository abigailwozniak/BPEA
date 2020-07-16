**this replicates the CPS results from table 7
***it uses cpi data from the CPS, the male unemp rate from the CPS, and then reads in CPS supplement data as provided by unicon

clear
set more off

*use "\\tsclient\G\research\data\cpi-month.dta", clear
use research/data/cpi-month.dta, clear
sort year
collapse (mean) cpi, by(year)
sort year
tempfile cpi
save `cpi', replace

*use "\\tsclient\G\research\mig-trend\dta\BD\UR-male.dta", clear
use research/mig-trend/dta/BD/UR-male.dta, clear
keep if year>=1948
replace year=year+1
rename ur_all_16p ur_curr
sort year
tempfile yearUR
save `yearUR', replace

*use "\\tsclient\G\research\mig-trend\dta\BD\UR-male.dta", clear
use research/mig-trend/dta/BD/UR-male.dta, clear
keep if year>=1948
rename  ur_all_16p ur_start
rename year yrstart
sort yrstart
tempfile yrUR
save `yrUR', replace

foreach y in 1979 1981 1983 1987 1991 1996 1998 2000 2002 2004 2006 2008 2010 2012 {
foreach yr of numlist 1948/`y' {
disp "y: `y'"
disp "yr: `yr'"
if `y'==`yr' qui sum ur_start if yrstart==`yr' 
else qui sum  ur_start if yrstart>=`yr' & yrstart<=(`y'-1)

local URmin`yr'_`y'=`r(min)'
}
}

*PENSION SUPPLEMENT, MAY

*use  "\\tsclient\G\mcr/scratch-m1cls01/data/cps/internallm/may79.dta" 
use mcr/scratch-m1cls01/data/cps/internallm/may79.dta, clear
keep if age>=21 & age<=64
keep if sex==1
replace wsyrs=. if wsyrs==99
gen yrstart=1979-wsyrs
replace yrstart=1979 if wsyr1==1
gen tenure=1979-yrstart
gen weekwage=ernhr*ernush/100 if ernpdh==1 & ernush>0 & ernhr>0
replace weekwage=ernwk if ernpdh==2 & ernwk>0
keep if yrstart>1947 & yrstart<=1979 & weekwage!=. & weekwage>0
gen ed=grdhi-1
replace ed=ed-1 if grdcom==2
replace ed=0 if ed<0
gen exp=age-ed
qui replace exp=0 if exp<0
rename wgtfnl weight
keep exp ed tenure ind occ divisn race marstat weight state smsark yrstart weekwage age
gen year=1979
tempfile temp1979
save `temp1979', replace

*use  "\\tsclient\G\mcr/scratch-m1cls01/data/cps/internallm/may83.dta" 
use mcr/scratch-m1cls01/data/cps/internallm/may83.dta, clear
keep if age>=21 & age<=64
keep if sex==1
replace wsyrs=. if wsyrs==99
gen yrstart=1983-wsyrs
replace yrstart=1983 if wsyr1==1
gen tenure=1983-yrstart
gen weekwage=ernhr*ernush/100 if ernpdh==1 & ernush>0 & ernhr>0
replace weekwage=ernwk if ernpdh==2 & ernwk>0
keep if yrstart>1947 & yrstart<=1983 & weekwage!=. & weekwage>0
gen ed=grdhi-1
replace ed=ed-1 if grdcom==2
replace ed=0 if ed<0
gen exp=age-ed
rename wgtfnl weight
keep exp ed tenure ind occ divisn race marstat weight state smsark yrstart weekwage age
gen year=1983
tempfile temp1983
save `temp1983', replace

*OCC TENURE + MOBILITY, JAN/FEB
*use  "\\tsclient\G\mcr/scratch-m1cls01/data/cps/internallm/jan81.dta" 
use mcr/scratch-m1cls01/data/cps/internallm/jan81.dta, clear
keep if age>=21 & age<=64
keep if sex==1
replace jobdur=. if jobdur==89
gen yrstart=jobdur+1900
gen tenure=1981-yrstart
gen weekwage=ernhr*ernush/100 if ernpdh==1 & ernush>0 & ernhr>0
replace weekwage=ernwk if ernpdh==2 & ernwk>0
keep if yrstart>1947 & yrstart<=1981 & weekwage!=. & weekwage>0
gen ed=grdhi-1
replace ed=ed-1 if grdcom==2
replace ed=0 if ed<0
gen exp=age-ed
rename wgtfnl weight
keep exp ed tenure ind occ race marstat weight state yrstart weekwage age
gen year=1981
tempfile temp1981
save `temp1981', replace

*use  "\\tsclient\G\mcr/scratch-m1cls01/data/cps/internallm/jan87.dta" 
use mcr/scratch-m1cls01/data/cps/internallm/jan87.dta, clear
keep if age>=21 & age<=64
keep if sex==1
gen tenure=samempyr if samempyr<=70
replace tenure=0 if samempmo<=12 & samempyr>=98
gen yrstart=1987-tenure
gen weekwage=ernhr*ernush/100 if ernpdh==1 & ernush>0 & ernhr>0
replace weekwage=ernwk if ernpdh==2 & ernwk>0
keep if yrstart>1947 & yrstart<=1987 & weekwage!=. & weekwage>0
gen ed=grdhi-1
replace ed=ed-1 if grdcom==2
replace ed=0 if ed<0
gen exp=age-ed
rename wgtfnl weight
keep exp ed tenure ind occ race marstat weight state yrstart weekwage age
gen year=1987
tempfile temp1987
save `temp1987', replace

*use  "\\tsclient\G\mcr/scratch-m1cls01/data/cps/internallm/jan91.dta" 
use mcr/scratch-m1cls01/data/cps/internallm/jan91.dta, clear
keep if age>=21 & age<=64
keep if sex==1
gen tenure=samempyr if samempyr<=70
replace tenure=0 if samempmo<=12 & samempyr>=98
gen yrstart=1991-tenure
gen weekwage=ernhr*ernush/100 if ernpdh==1 & ernush>0 & ernhr>0
replace weekwage=ernwk if ernpdh==2 & ernwk>0
keep if yrstart>1947 & yrstart<=1991 & weekwage!=. & weekwage>0
gen ed=grdhi
replace ed=ed-1 if grdcom==2
replace ed=0 if ed<0
gen exp=age-ed
rename wgtfnl weight
keep exp ed tenure ind occ race marstat weight state yrstart weekwage age
gen year=1991
tempfile temp1991
save `temp1991', replace

*use  "\\tsclient\G\mcr/scratch-m1cls01/data/cps/internallm/jan96f.dta" 
use mcr/scratch-m1cls01/data/cps/internallm/jan96f.dta, clear
keep if age>=21 & age<=64
keep if sex==1
gen tenure=floor(tencont/100) 
replace tenure=. if tenure<0

gen yrstart=1996-tenure
gen weekwage=ernhr*ernush/100 if ernush>0 & ernhr>0 
replace weekwage=ernwk/100 if (ernhr==. | ernhr<=0) & ernwk>0 & ernwk!=.
keep if yrstart>1947 & yrstart<=1996 & weekwage!=. & weekwage>0

gen ed=.
replace ed=0 if grdatn==0 | grdatn==31
replace ed=4 if grdatn==32
replace ed=6 if grdatn==33
replace ed=8 if grdatn==34
replace ed=9 if grdatn==35
replace ed=10 if grdatn==36
replace ed=11 if grdatn==37
replace ed=11 if grdatn==38
replace ed=12 if grdatn==39
replace ed=13 if grdatn==40
replace ed=14 if grdatn==41 | grdatn==42
replace ed=16 if grdatn==43
replace ed=18 if grdatn==44
replace ed=20 if grdatn==45 | grdatn==46

replace ed=0 if ed<0 | ed==.
gen exp=age-ed
rename wgtfnl weight
keep exp ed tenure ind occ race marstat weight state yrstart weekwage age
gen year=1996
tempfile temp1996
save `temp1996', replace

*use  "\\tsclient\G\mcr/scratch-m1cls01/data/cps/internallm/jan98f.dta" 
use mcr/scratch-m1cls01/data/cps/internallm/jan98f.dta, clear
keep if age>=21 & age<=64
keep if sex==1
gen tenure=floor(tencont/100) 
replace tenure=. if tenure<0

gen yrstart=1998-tenure
gen weekwage=ernhr*ernush/100 if ernush>0 & ernhr>0 
replace weekwage=ernwk/100 if (ernhr==. | ernhr<=0) & ernwk>0 & ernwk!=.
keep if yrstart>1947 & yrstart<=1998 & weekwage!=. & weekwage>0

gen ed=.
replace ed=0 if grdatn==0 | grdatn==31
replace ed=4 if grdatn==32
replace ed=6 if grdatn==33
replace ed=8 if grdatn==34
replace ed=9 if grdatn==35
replace ed=10 if grdatn==36
replace ed=11 if grdatn==37
replace ed=11 if grdatn==38
replace ed=12 if grdatn==39
replace ed=13 if grdatn==40
replace ed=14 if grdatn==41 | grdatn==42
replace ed=16 if grdatn==43
replace ed=18 if grdatn==44
replace ed=20 if grdatn==45 | grdatn==46

replace ed=0 if ed<0 | ed==.
gen exp=age-ed
rename wgtfnl weight
keep exp ed tenure ind occ race marstat weight state yrstart weekwage age
gen year=1998
tempfile temp1998
save `temp1998', replace

*use  "\\tsclient\G\mcr/scratch-m1cls01/data/cps/internallm/jan00f.dta" 
use mcr/scratch-m1cls01/data/cps/internallm/jan00f.dta, clear
keep if age>=21 & age<=64
keep if sex==1
gen tenure=floor(tencont/100) 
replace tenure=. if tenure<0

gen yrstart=2000-tenure
gen weekwage=ernhr*ernush/100 if ernush>0 & ernhr>0 
replace weekwage=ernwk/100 if (ernhr==. | ernhr<=0) & ernwk>0 & ernwk!=.
keep if yrstart>1947 & yrstart<=2000 & weekwage!=. & weekwage>0

gen ed=.
replace ed=0 if grdatn==0 | grdatn==31
replace ed=4 if grdatn==32
replace ed=6 if grdatn==33
replace ed=8 if grdatn==34
replace ed=9 if grdatn==35
replace ed=10 if grdatn==36
replace ed=11 if grdatn==37
replace ed=11 if grdatn==38
replace ed=12 if grdatn==39
replace ed=13 if grdatn==40
replace ed=14 if grdatn==41 | grdatn==42
replace ed=16 if grdatn==43
replace ed=18 if grdatn==44
replace ed=20 if grdatn==45 | grdatn==46

replace ed=0 if ed<0 | ed==.
gen exp=age-ed
rename wgtfnl weight
keep exp ed tenure ind occ race marstat weight state yrstart weekwage age
gen year=2000
tempfile temp2000
save `temp2000', replace

foreach yr in 02 04 06 08 10 12 {
local year=2000+`yr'
disp "year: `year'"

*use  "\\tsclient\G\mcr/scratch-m1cls01/data/cps/internallm/jan`yr'.dta" 
use mcr/scratch-m1cls01/data/cps/internallm/jan`yr'.dta, clear
qui keep if age>=21 & age<=64
qui keep if sex==1
qui gen tenure=floor(tencont/100) 
qui replace tenure=. if tenure<0

qui gen yrstart=`year'-tenure
qui gen weekwage=ernhr*ernush/100 if ernush>0 & ernhr>0 
qui replace weekwage=ernwk/100 if (ernhr==. | ernhr<=0) & ernwk>0 & ernwk!=.
qui keep if yrstart>1947 & yrstart<=`year' & weekwage!=. & weekwage>0

qui gen ed=.
qui replace ed=0 if grdatn==0 | grdatn==31
qui replace ed=4 if grdatn==32
qui replace ed=6 if grdatn==33
qui replace ed=8 if grdatn==34
qui replace ed=9 if grdatn==35
qui replace ed=10 if grdatn==36
qui replace ed=11 if grdatn==37
qui replace ed=11 if grdatn==38
qui replace ed=12 if grdatn==39
qui replace ed=13 if grdatn==40
qui replace ed=14 if grdatn==41 | grdatn==42
qui replace ed=16 if grdatn==43
qui replace ed=18 if grdatn==44
qui replace ed=20 if grdatn==45 | grdatn==46

qui replace ed=0 if ed<0 | ed==.
qui gen exp=age-ed
qui rename wgtfnl weight
keep exp ed tenure ind occ race marstat weight state yrstart weekwage age
gen year=`year'
tempfile temp`year'
save `temp`year'', replace
}

use `temp1979'
foreach yr in 1981 1983 1987 1991 1996 1998 2000 2002 2004 2006 2008 2010 2012 {
append using `temp`yr''
}

replace weight=weight/100 if year>=1996

sort yrstart
merge yrstart using `yrUR'
tab year
assert _merge==3 | _merge==2
keep if _merge==3
drop _merge


gen indmaj=.
*ag
qui replace indmaj=1 if ind>=17 & ind<=29 & (year==1979 | year==1981)
qui replace indmaj=1 if ind>=10 & ind<=31 & (year==1983 | year==1987 | year==1991)
qui replace indmaj=1 if ind>=10 & ind<=32 & (year>=1996 & year<=2002)
qui replace indmaj=1 if ind>=170 & ind<=290 & (year>=2004)

*mining
qui replace indmaj=2 if ind>=47 & ind<=58 & (year==1979 | year==1981)
qui replace indmaj=2 if ind>=40 & ind<=50 & (year==1983 | year==1987 | year==1991)
qui replace indmaj=2 if ind>=40 & ind<=50 & (year>=1996 & year<=2002)
qui replace indmaj=2 if ind>=370 & ind<=490 & (year>=2004)

*construction
qui replace indmaj=3 if ind>=67 & ind<=78 & (year==1979 | year==1981)
qui replace indmaj=3 if ind==60 & (year==1983 | year==1987 | year==1991)
qui replace indmaj=3 if ind==60 & (year>=1996 & year<=2002)
qui replace indmaj=3 if ind==770 & (year>=2004)

*manuf
qui replace indmaj=4 if ind>=107 & ind<=398 & (year==1979 | year==1981)
qui replace indmaj=4 if ind>=100 & ind<=392 & (year==1983 | year==1987 | year==1991)
qui replace indmaj=4 if ind>=100 & ind<=392 & (year>=1996 & year<=2002)
qui replace indmaj=4 if ind>=1070 & ind<=3990 & (year>=2004)

*transport + info/comm + utilities
qui replace indmaj=5 if ind>=407 & ind<=499 & (year==1979 | year==1981)
qui replace indmaj=5 if ind>=400 & ind<=472 & (year==1983 | year==1987 | year==1991)
qui replace indmaj=5 if ind>=400 & ind<=472 & (year>=1996 & year<=2002)
qui replace indmaj=5 if ind>=6070 & ind<=6780 & (year>=2004)

*wholesale and retail
qui replace indmaj=6 if ind>=507 & ind<=699 & (year==1979 | year==1981)
qui replace indmaj=6 if ind>=500 & ind<=691 & (year==1983 | year==1987 | year==1991)
qui replace indmaj=6 if ind>=500 & ind<=691 & (year>=1996 & year<=2002)
qui replace indmaj=6 if ind>=4070 & ind<=5790 & (year>=2004)

*FIRE
qui replace indmaj=7 if ind>=707 & ind<=719 & (year==1979 | year==1981)
qui replace indmaj=7 if ind>=700 & ind<=712 & (year==1983 | year==1987 | year==1991)
qui replace indmaj=7 if ind>=700 & ind<=712 & (year>=1996 & year<=2002)
qui replace indmaj=7 if ind>=6870 & ind<=7190 & (year>=2004)

*Bus and repair services
qui replace indmaj=8 if ind>=727 & ind<=767 & (year==1979 | year==1981)
qui replace indmaj=8 if ind>=721 & ind<=760 & (year==1983 | year==1987 | year==1991)
qui replace indmaj=8 if ind>=721 & ind<=760 & (year>=1996 & year<=2002)
qui replace indmaj=8 if ( (ind>=7570 & ind<=7790) | (ind>=8770 & ind<=8880)) & (year>=2004)

*Personal services
qui replace indmaj=9 if ind>=769 & ind<=799 & (year==1979 | year==1981)
qui replace indmaj=9 if ind>=761 & ind<=797 & (year==1983 | year==1987 | year==1991)
qui replace indmaj=9 if ind>=761 & ind<=791 & (year>=1996 & year<=2002)
qui replace indmaj=9 if ( (ind>=8890 & ind<=9290) | (ind>=8660 & ind<=8690)) & (year>=2004)

*entertainment
qui replace indmaj=10 if ind>=807 & ind<=817 & (year==1979 | year==1981)
qui replace indmaj=10 if ind>=800 & ind<=802 & (year==1983 | year==1987 | year==1991)
qui replace indmaj=10 if ind>=800 & ind<=810 & (year>=1996 & year<=2002)
qui replace indmaj=10 if ind>=8560 & ind<=8590 & (year>=2004)

*prof services
qui replace indmaj=11 if ind>=828 & ind<=899 & (year==1979 | year==1981)
qui replace indmaj=11 if ind>=812 & ind<=892 & (year==1983 | year==1987 | year==1991)
qui replace indmaj=11 if ind>=812 & ind<=892 & (year>=1996 & year<=2002)
qui replace indmaj=11 if ( (ind>=7860 & ind<=8470) | (ind>=7270 & ind<=7490)) & (year>=2004)

*pub admin
qui replace indmaj=12 if ind>=907 & ind<=947 & (year==1979 | year==1981)
qui replace indmaj=12 if ind>=900 & ind<=932 & (year==1983 | year==1987 | year==1991)
qui replace indmaj=12 if ind>=900 & ind<=932 & (year>=1996 & year<=2002)
qui replace indmaj=12 if ind>=9370 & ind<=9590 & (year>=2004)

gen ur_min=.

tab year
sort year
merge year using `yearUR'
assert _merge==3 | _merge==2
keep if _merge==3
drop _merge
tab year

sort year
merge year using `cpi' 
keep if _merge==3
drop _merge

gen logwage=log(weekwage*cpi/100)

foreach yr in 1979 1981 1983 1987 1991 1996 1998 2000 2002 2004 2006 2008 2010 2012 {
qui sum yrstart if year==`yr'
local y`yr'max=`r(max)'
foreach y of numlist 1948/`y`yr'max' {
disp "yr: `yr'"
qui replace ur_min=`URmin`y'_`yr'' if year==`yr' & yrstart==`y'
}
}

gen exp2=exp^2
gen nonwhite=(race!=1)
gen married=(marstat==1)

gen region=1 if state>=11 & state<=16
replace region=2 if state>=21 & state<=23
replace region=3 if state>=31 & state<=35
replace region=4 if state>=41 & state<=47
replace region=5 if state>=51 & state<=59
replace region=6 if state>=61 & state<=64
replace region=7 if state>=71 & state<=74
replace region=8 if state>=81 & state<=88
replace region=9 if state>=91 & state<=95

gen age2=age^2
gen tenure2=tenure^2
gen year2=year^2

mat A=J(25,2,0)
keep if age>=21 & age<=64

local k=1
foreach ag in 0 1 {
preserve
if `ag'==1 keep if age>=22 & age<=33

gen y1980=(year<=1989)
gen y1990=(year>=1990 & year<=1999)
gen y2000=(year>=2000 & year<=2012)

foreach var of varlist ur_curr ur_start ur_min {
gen `var'_y1980=`var'*y1980
gen `var'_y1990=`var'*y1990
gen `var'_y2000=`var'*y2000
}

xi: reg logwage ur_curr_y1980 ur_curr_y1990 ur_curr_y2000 ur_start_y1980 ur_start_y1990 ur_start_y2000 ur_min_y1980 ur_min_y1990 ur_min_y2000 age age2 tenure tenure2 nonwhite married year year2 i.ed i.indmaj i.region [aw=weight], robust 


local i=3
foreach v in ur_curr_y1980 ur_curr_y1990 ur_curr_y2000 {
mat A[`i',`k']=_b[`v']
local ++i
mat A[`i',`k']=_se[`v']
local ++i
}

local i=11
foreach v in ur_start_y1980 ur_start_y1990 ur_start_y2000 {
mat A[`i',`k']=_b[`v']
local ++i
mat A[`i',`k']=_se[`v']
local ++i
}

local i=19
foreach v in ur_min_y1980 ur_min_y1990 ur_min_y2000 {
mat A[`i',`k']=_b[`v']
local ++i
mat A[`i',`k']=_se[`v']
local ++i
}
mat A[25,`k']=`e(N)'
local ++k
restore
}
drop _all
svmat A
save research/brookings-dynamism/output/pub/table-7-cps.dta, replace



