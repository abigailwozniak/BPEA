log using stateregs_gss.log, replace
set more off

/*** Code adapted from Raven's file stateregs.do to estimate state regs using state-level GSS measures from restricted data ***/

use socialcap_stateid.dta
rename fipsstat state
sort state year
*summ
tempfile temp_gss
save `temp_gss', replace
clear

use stateregs, replace
drop timet timet2
* Missing some states in early 1970s, so can't use Raven's coding to generate timet
tab1 year
* Create new timet that starts with 1 in 1973, first year of gss vars
*gen timet = 1 if year==1973
sort state year
*quietly by state: replace timet = timet[_n-1]+1 if year>=1974
gen timet=(year - 1972) if year >= 1973
gen timet2 = timet^2
summ state year stateur stateur1 timet
summ state year stateur stateur1 timet if year >=1973
summ state year stateur stateur1 timet if year <=1967

* this loop estimates the trend for each measure of fluidity plus also union
foreach V of var en eu ue ne empchange migstate jcr jdr union {
   quietly for num 1/2 4/6 8/13 15/42 44/51 53/56: reg `V' stateur stateur1 timet if state==X \ replace `V'trend = _b[timet] if state==X
   /*
   quietly for num 1/2 4/6 8/13 15/42 44/51 53/56: reg `V' stateur stateur1 timet if state==X & year>=1998 \ replace `V'trend98 = _b[timet] if state==X
   quietly for num 1/2 4/6 8/13 15/42 44/51 53/56: reg `V' stateur stateur1 timet single mfg serv age2334 age3544 age4564 if state==X \ replace `V'trendb = _b[timet] if state==X
   reg `V' stateur stateur1 state1-state2 state4-state6 state8-state13 state15-state42 state44-state51 state53-state56 state1t-state2t state4t-state6t state8t-state13t state15t-state42t state44t-state51t state53t-state56t  , noc
   quietly for num 1/2 4/6 8/13 15/42 44/51 53/56: replace `V'trend = _b[stateXt] if state==X
   reg `V' stateur stateur1 state1-state2 state4-state6 state8-state13 state15-state42 state44-state51 state53-state56 state1t-state2t state4t-state6t state8t-state13t state15t-state42t state44t-state51t state53t-state56t if year>=1998 , noc
   quietly for num 1/2 4/6 8/13 15/42 44/51 53/56: replace `V'trend98 = _b[stateXt] if state==X
  */
}

* Now PCA second - f1ptrend now measure of fluidity
factor entrend eutrend uetrend netrend empchangetrend migstatetrend jcrtrend jdrtrend if year==2000
predict f1ptrend if e(sample)

*merge 1:1 state year using state_hr_rate_Stata13
merge 1:1 state year using `temp_gss'
summ year state if _merge==2
drop _merge

* trend in social cap measures - not all states have sufficient obs 
gen trusttrend = .
gen memtrend = .
qui for num 1/2 4/6 8/13 15/42 44/51 53/56: estimates clear \ capture reg trustd stateur stateur1 timet if state==X \  capture replace trusttrend = _b[timet] if state==X & e(N) >= 10
qui for num 1/2 4/6 8/13 15/42 44/51 53/56: estimates clear \ capture reg memnum stateur stateur1 timet if state==X \  capture replace memtrend = _b[timet] if state==X & e(N) >= 10

summ state year f1ptrend trusttrend memtrend
summ state year f1ptrend trusttrend memtrend if year==2000

egen stdf1=std(f1ptrend)
egen stdtrust=std(trusttrend)
egen stdmem=std(memtrend)

summ state year std*

* graph of trend in social cap and trend in fluidity 
gr twoway scatter stdf1 stdmem if year==2000, saving(memtrend, replace) title("State Trends in Fluidity and GSS Membership Index")
gr twoway scatter stdf1 stdtrust if year==2000, saving(trusttrend, replace) title("State Trends in Fluidity and GSS Trust Indicator") yscale(range(-2(1)2))
gr twoway scatter stdf1 stdtrust if year==2000 & inlist(state,4,8,16,35,30,49,32,56,6,41,53)==1, saving(trusttrend_west, replace) title("State Trends in Fluidity and GSS Trust Indicator - West Only")

* univariate regs
reg stdf1 stdmem if year==2000
reg stdf1 stdmem if year==2000 & inlist(state,4,8,16,35,30,49,32,56,6,41,53)==1

reg stdf1 stdtrust if year==2000
reg stdf1 stdtrust if year==2000 & stdtrust < 2

* Western region only, then western region minus AK and HI
reg stdf1 stdtrust if year==2000 & inlist(state,4,8,16,35,30,49,32,56,2,6,15,41,53)==1
reg stdf1 stdtrust if year==2000 & inlist(state,4,8,16,35,30,49,32,56,6,41,53)==1

* data for graphs excluding AK and HI
gen west=inlist(state,4,8,16,35,30,49,32,56,2,6,15,41,53)==1
tab1 west if year==2000
export excel stdf1 stdtrust stdmem state west using trustscatter.xlsx if year==2000 & state~=2 & state~=15, firstrow(var) replace


* multivariate regs - first trust and mem together
reg stdf1 stdmem stdtrust if year==2000
reg stdf1 stdmem stdtrust if year==2000 & inlist(state,4,8,16,35,30,49,32,56,6,41,53)==1


* multivariate regs - trust and mem added to other state panel regs
gen decade = 1 if year>=1977 & year<=1979
replace decade = 2 if year>=1980 & year<=1989
replace decade = 3 if year>=1990 & year<=1999
replace decade = 4 if year>=2000 & year<=2014

summ union uniontrend

quietly for var f1 age* lths hsdeg somecol collplus married single female mfg retail fire serv ag gov selfemp manprof techocc servocc prodocc opocc adminocc salesocc military inschool owner p9010 union primemale primefemale trustd memnum: egen mX = mean(X), by(state decade)
quietly for var age* lths hsdeg somecol collplus married single female mfg retail fire serv ag gov selfemp  manprof techocc servocc prodocc opocc adminocc salesocc military inschool owner p9010 union trustd memnum: gen temp = mX if year==1989 \ egen mX80s = mean(temp), by(state) \ drop temp
quietly for var age* lths hsdeg somecol collplus married single female mfg retail fire serv ag gov selfemp manprof techocc servocc prodocc opocc adminocc salesocc military owner p9010 union primemale primefemale trustd memnum: gen temp = mX if year>=1977 & year<=1979 \ egen mX70s = mean(temp), by(state) \ drop temp
*quietly for var f1trend  f1trendb f1ptrend f1trend98 f1ptrend98 f1ptrendfh f1ptrendsh mmfg70s mretail70s mfire70s mserv70s mag70s mage182270s mage233470s mage354470s mage456470s mage64p70s mmanprof70s mtechocc70s mservocc70s mprodocc70s mopocc70s madminocc70s msalesocc70s manproftrend techocctrend servocctrend prodocctrend opocctrend adminocctrend salesocctrend mlths70s mhsdeg70s msomecol70s mcollplus70s mowner70s mp901070s age1822trend age2334trend age3544trend age4564trend age64ptrend ownertrend p9010trend mfgtrend agtrend retailtrend firetrend servtrend lthstrend hsdegtrend somecoltrend collplustrend mmarried70s msingle70s marriedtrend singletrend munion70s uniontrend mgov70s govtrend mselfemp70s selfemptrend mprimemale70s mprimefemale70s primemaletrend primefemaletrend dh8810: sum X if year==2000 \ gen Xd = (X-r(mean))/r(sd)
quietly for var f1ptrend mmfg70s mretail70s mfire70s mserv70s mag70s mage182270s mage233470s mage354470s mage456470s mage64p70s mmanprof70s mtechocc70s mservocc70s mprodocc70s mopocc70s madminocc70s msalesocc70s manproftrend techocctrend servocctrend prodocctrend opocctrend adminocctrend salesocctrend mlths70s mhsdeg70s msomecol70s mcollplus70s mowner70s mp901070s age1822trend age2334trend age3544trend age4564trend age64ptrend ownertrend p9010trend mfgtrend agtrend retailtrend firetrend servtrend lthstrend hsdegtrend somecoltrend collplustrend mmarried70s msingle70s marriedtrend singletrend munion70s uniontrend mgov70s govtrend mselfemp70s selfemptrend mprimemale70s mprimefemale70s primemaletrend primefemaletrend mtrustd70s mmemnum70s: sum X if year==2000 \ gen Xd = (X-r(mean))/r(sd)
 
 corr mtrustd70sd stdtrust
 corr mmemnum70sd stdmem
 
* Reg - took out age trend - added levels plus trends, levels only, trends only for trust and mem, then for just trust

reg f1ptrendd mtrustd70sd mmemnum70sd stdtrust stdmem madminocc70sd mopocc70sd uniontrendd cendiv2 cendiv8 cendiv9 if year==2000
reg f1ptrendd mtrustd70sd mmemnum70sd madminocc70sd mopocc70sd uniontrendd cendiv2 cendiv8 cendiv9 if year==2000
reg f1ptrendd stdtrust stdmem madminocc70sd mopocc70sd uniontrendd cendiv2 cendiv8 cendiv9 if year==2000

reg f1ptrendd mtrustd70sd stdtrust madminocc70sd mopocc70sd uniontrendd cendiv2 cendiv8 cendiv9 if year==2000
reg f1ptrendd mtrustd70sd madminocc70sd mopocc70sd uniontrendd cendiv2 cendiv8 cendiv9 if year==2000
reg f1ptrendd stdtrust madminocc70sd mopocc70sd uniontrendd cendiv2 cendiv8 cendiv9 if year==2000

reg f1ptrendd mmemnum70sd stdmem madminocc70sd mopocc70sd uniontrendd cendiv2 cendiv8 cendiv9 if year==2000
reg f1ptrendd mmemnum70sd madminocc70sd mopocc70sd uniontrendd cendiv2 cendiv8 cendiv9 if year==2000
reg f1ptrendd stdmem madminocc70sd mopocc70sd uniontrendd cendiv2 cendiv8 cendiv9 if year==2000

* Take out union

reg f1ptrendd mtrustd70sd mmemnum70sd stdtrust stdmem madminocc70sd mopocc70sd cendiv2 cendiv8 cendiv9 if year==2000
reg f1ptrendd mtrustd70sd mmemnum70sd madminocc70sd mopocc70sd cendiv2 cendiv8 cendiv9 if year==2000
reg f1ptrendd stdtrust stdmem madminocc70sd mopocc70sd cendiv2 cendiv8 cendiv9 if year==2000

reg f1ptrendd mtrustd70sd stdtrust madminocc70sd mopocc70sd cendiv2 cendiv8 cendiv9 if year==2000
reg f1ptrendd mtrustd70sd madminocc70sd mopocc70sd cendiv2 cendiv8 cendiv9 if year==2000
reg f1ptrendd stdtrust madminocc70sd mopocc70sd cendiv2 cendiv8 cendiv9 if year==2000

reg f1ptrendd mmemnum70sd stdmem madminocc70sd mopocc70sd cendiv2 cendiv8 cendiv9 if year==2000
reg f1ptrendd mmemnum70sd madminocc70sd mopocc70sd cendiv2 cendiv8 cendiv9 if year==2000
reg f1ptrendd stdmem madminocc70sd mopocc70sd cendiv2 cendiv8 cendiv9 if year==2000

log close
clear

