* analysis of trends by state
set trace off
set more 1 
capture log close
clear
set linesize 250

adopath + g:/ado/plus
log using stateregs.log, replace

use "Input/WHARTON LAND REGULATION DATA_1_24_2008.dta", clear
drop state
gen state = 2 if statename=="AK"
replace state = 1 if statename=="AL"
replace state = 05 if statename=="AR"
replace state = 60 if statename=="AS"
replace state = 04 if statename=="AZ"
replace state = 06 if statename=="CA"
replace state = 08 if statename=="CO"
replace state = 09 if statename=="CT"
replace state = 11 if statename=="DC"
replace state = 10 if statename=="DE"
replace state = 12 if statename=="FL"
replace state = 13 if statename=="GA"
replace state = 66 if statename=="GU"
replace state = 15 if statename=="HI"
replace state = 19 if statename=="IA"
replace state = 16 if statename=="ID"
replace state = 17 if statename=="IL"
replace state = 18 if statename=="IN"
replace state = 20 if statename=="KS"
replace state = 21 if statename=="KY"
replace state = 22 if statename=="LA"
replace state = 25 if statename=="MA"
replace state = 24 if statename=="MD"
replace state = 23 if statename=="ME"
replace state = 26 if statename=="MI"
replace state = 27 if statename=="MN"
replace state = 29 if statename=="MO"
replace state = 28 if statename=="MS"
replace state = 30 if statename=="MT"
replace state = 37 if statename=="NC"
replace state = 38 if statename=="ND"
replace state = 31 if statename=="NE"
replace state = 33 if statename=="NH"
replace state = 34 if statename=="NJ"
replace state = 35 if statename=="NM"
replace state = 32 if statename=="NV"
replace state = 36 if statename=="NY"
replace state = 39 if statename=="OH"
replace state = 40 if statename=="OK"
replace state = 41 if statename=="OR"
replace state = 42 if statename=="PA"
replace state = 72 if statename=="PR"
replace state = 44 if statename=="RI"
replace state = 45 if statename=="SC"
replace state = 46 if statename=="SD"
replace state = 47 if statename=="TN"
replace state = 48 if statename=="TX"
replace state = 49 if statename=="UT"
replace state = 51 if statename=="VA"
replace state = 78 if statename=="VI"
replace state = 50 if statename=="VT"
replace state = 53 if statename=="WA"
replace state = 55 if statename=="WI"
replace state = 54 if statename=="WV"
replace state = 56 if statename=="WY"
tab statename if state==.
collapse (mean) wharton=WRLURI [pw=weight], by(state)
save Output/wharton, replace
* http://unionstats.gsu.edu/MonthlyLaborReviewArticle.htm
insheet using Input/State_Union_Membership_Density_1964-2015.csv, clear
gen state = 2 if statename=="Alaska"
replace state = 1 if statename=="Alabama"
replace state = 05 if statename=="Arkansas"
replace state = 04 if statename=="Arizona"
replace state = 06 if statename=="California"
replace state = 08 if statename=="Colorado"
replace state = 09 if statename=="Connecticut"
replace state = 11 if statename=="District of Columbia"
replace state = 10 if statename=="Delaware"
replace state = 12 if statename=="Florida"
replace state = 13 if statename=="Georgia"
replace state = 15 if statename=="Hawaii"
replace state = 19 if statename=="Iowa"
replace state = 16 if statename=="Idaho"
replace state = 17 if statename=="Illinois"
replace state = 18 if statename=="Indiana"
replace state = 20 if statename=="Kansas"
replace state = 21 if statename=="Kentucky"
replace state = 22 if statename=="Louisiana"
replace state = 25 if statename=="Massachusetts"
replace state = 24 if statename=="Maryland"
replace state = 23 if statename=="Maine"
replace state = 26 if statename=="Michigan"
replace state = 27 if statename=="Minnesota"
replace state = 29 if statename=="Missouri"
replace state = 28 if statename=="Mississippi"
replace state = 30 if statename=="Montana"
replace state = 37 if statename=="North Carolina"
replace state = 38 if statename=="North Dakota"
replace state = 31 if statename=="Nebraska"
replace state = 33 if statename=="New Hampshire"
replace state = 34 if statename=="New Jersey"
replace state = 35 if statename=="New Mexico"
replace state = 32 if statename=="Nevada"
replace state = 36 if statename=="New York"
replace state = 39 if statename=="Ohio"
replace state = 40 if statename=="Oklahoma"
replace state = 41 if statename=="Oregon"
replace state = 42 if statename=="Pennsylvania"
replace state = 44 if statename=="Rhode Island"
replace state = 45 if statename=="South Carolina"
replace state = 46 if statename=="South Dakota"
replace state = 47 if statename=="Tennessee"
replace state = 48 if statename=="Texas"
replace state = 49 if statename=="Utah"
replace state = 51 if statename=="Virginia"
replace state = 50 if statename=="Vermont"
replace state = 53 if statename=="Washington"
replace state = 55 if statename=="Wisconsin"
replace state = 54 if statename=="West Virginia"
replace state = 56 if statename=="Wyoming"
drop if state==.
quietly for num 0/9: rename mem0X memX
reshape long mem, i(state) j(year)
replace year = year+1900
replace year = year+100 if year<=1920
gen union = mem/100
keep state year union
save Output/union, replace

insheet using Input/statepop6010.csv, clear
drop if stateab==""
gen state = 2 if stateab=="AK"
replace state = 1 if stateab=="AL"
replace state = 05 if stateab=="AR"
replace state = 60 if stateab=="AS"
replace state = 04 if stateab=="AZ"
replace state = 06 if stateab=="CA"
replace state = 08 if stateab=="CO"
replace state = 09 if stateab=="CT"
replace state = 11 if stateab=="DC"
replace state = 10 if stateab=="DE"
replace state = 12 if stateab=="FL"
replace state = 13 if stateab=="GA"
replace state = 66 if stateab=="GU"
replace state = 15 if stateab=="HI"
replace state = 19 if stateab=="IA"
replace state = 16 if stateab=="ID"
replace state = 17 if stateab=="IL"
replace state = 18 if stateab=="IN"
replace state = 20 if stateab=="KS"
replace state = 21 if stateab=="KY"
replace state = 22 if stateab=="LA"
replace state = 25 if stateab=="MA"
replace state = 24 if stateab=="MD"
replace state = 23 if stateab=="ME"
replace state = 26 if stateab=="MI"
replace state = 27 if stateab=="MN"
replace state = 29 if stateab=="MO"
replace state = 28 if stateab=="MS"
replace state = 30 if stateab=="MT"
replace state = 37 if stateab=="NC"
replace state = 38 if stateab=="ND"
replace state = 31 if stateab=="NE"
replace state = 33 if stateab=="NH"
replace state = 34 if stateab=="NJ"
replace state = 35 if stateab=="NM"
replace state = 32 if stateab=="NV"
replace state = 36 if stateab=="NY"
replace state = 39 if stateab=="OH"
replace state = 40 if stateab=="OK"
replace state = 41 if stateab=="OR"
replace state = 42 if stateab=="PA"
replace state = 72 if stateab=="PR"
replace state = 44 if stateab=="RI"
replace state = 45 if stateab=="SC"
replace state = 46 if stateab=="SD"
replace state = 47 if stateab=="TN"
replace state = 48 if stateab=="TX"
replace state = 49 if stateab=="UT"
replace state = 51 if stateab=="VA"
replace state = 78 if stateab=="VI"
replace state = 50 if stateab=="VT"
replace state = 53 if stateab=="WA"
replace state = 55 if stateab=="WI"
replace state = 54 if stateab=="WV"
replace state = 56 if stateab=="WY"
l stateab if state==.
replace pop60 = pop60*1000
replace pop70 = pop70*1000
save Output/statepop6010, replace

* labor market flows from Unicon
use Input/state-level-data.dta if year>=1977, clear
keep migstate empchange state year en eu ue ne 

cd ../CPS_Data_Setup/.

*merge 1:1 state year using cpscovariates
merge 1:1 state year using Output/cpscovariates
drop _merge
drop if state>56

cd ../Table_4_A6_Fig_6_10_12/.

merge m:1 state using output/wharton
tab state if _merge==1
drop _merge
sort state year
quietly for var empchangeipums smigrant: quietly by state: gen X1 = X[_n+1]
replace migstate = . if year==1984 | year<=1979
sort state year
quietly by state: replace migstate = migstate[_n-1]*smigrant1/smigrant1[_n-1] if year>=2013
quietly by state: replace empchange = empchange[_n-1]*empchangeipums1/empchangeipums1[_n-1] if year>=2013

merge m:1 state using Output/statepop6010
drop _merge
* percentiles of the wage distribution from the CPS
merge 1:1 state year using Input/cps-pctiles-all, keepusing(p10 p90)
drop _merge
gen p9010 = log(p90/p10)

gen cendiv = 1 if state==9 | state==23 | state==25 | state==33 | state==44 | state==50
replace cendiv = 2 if state==34 | state==36 | state==42
replace cendiv = 3 if state==17 | state==18 | state==26 | state==39 | state==55 
replace cendiv = 4 if state==19 | state==20 | state==27 | state==29 | state==31 | state==38 | state==46
replace cendiv = 5 if state==10 | state==11 | state==12 | state==13 | state==24 | state==37 | state==45 | state==51 | state==54
replace cendiv = 6 if state==1  | state==21 | state==28 | state==47
replace cendiv = 7 if state==5  | state==22 | state==40 | state==48
replace cendiv = 8 if state==4  | state==8  | state==16 | state==30  | state==32 | state==35  | state==49 | state==56
replace cendiv = 9 if state==2  | state==6  | state==15 | state==41 | state==53
lab def cendiv 1 "New England" 2 "Mid Atlantic" 3 "East North Central" 4 "West North Centeral" 5 "South Atlantic" 6 "East South Central" 7 "West Sounth Central" 8 "Mountain" 9 "Pacific"
lab val cendiv cendiv
quietly tab cendiv, gen(cendiv)

factor en eu ue ne empchange migstate jcr jdr
predict f1 if e(sample)
mat f1mat = r(scoef)
scalar f1sum = f1mat[1,1]+f1mat[2,1]+f1mat[3,1]+f1mat[4,1]+f1mat[5,1]+f1mat[6,1]+f1mat[7,1]+f1mat[8,1]
gen f1mean = (f1mat[1,1]*en+f1mat[2,1]*eu+f1mat[3,1]*ue+f1mat[4,1]*ne+f1mat[5,1]*empchange+f1mat[6,1]*migstate+f1mat[7,1]*jcr+f1mat[8,1]*jdr)/f1sum
sum f1mean if year==1980, det

* state unemployment from the BLS
merge 1:1 state year using Input/stateur
drop _merge
merge 1:1 state year using Output/union
drop if _merge==2
drop _merge

gen timet = 1 if year==1977
sort state year
quietly by state: replace timet = timet[_n-1]+1 if year>=1978
gen timet2 = timet^2
quietly for num 1/3: quietly by state: gen stateurX = stateur[_n-X]
quietly for num 1/56: gen stateX = state==X 
quietly for num 1/56: gen stateXt = stateX*timet
quietly for num 1/56: gen stateXt2 = stateX*timet2
quietly for num 1/56: gen stateXur = stateX*stateur
quietly for num 1/56: gen stateXur1 = stateX*stateur1
quietly for var f1 owner p9010 age64p age1822 age2334 age3544 age4564 primemale primefemale en eu ue ne empchange migstate jcr jdr mfg ag serv retail fire gov selfemp manprof techocc servocc prodocc opocc adminocc salesocc military lths hsdeg somecol collplus married single union: gen Xtrend = .
quietly for var f1 owner p9010 age64p age2334 en eu ue ne empchange migstate jcr jdr : gen Xtrend98 = .
gen y9713 = year>=1997
gen timet97 = timet*y9713

egen mpop = mean(pop), by(state)
sum f1 if year==1980 [w=mpop]
gen f180 = r(mean)
reg f1  timet state1-state2 state4-state6 state8-state13 state15-state42 state44-state51 state53-state56 state1ur-state2ur state4ur-state6ur state8ur-state13ur state15ur-state42ur state44ur-state51ur state53ur-state56ur state1ur1-state2ur1 state4ur1-state6ur1 state8ur1-state13ur1 state15ur1-state42ur1 state44ur1-state51ur1 state53ur1-state56ur1 [w=mpop], noc
sum f1mean [w=mpop] if year==1980
gen relf1trendnat = _b[timet]/r(mean)
gen f1trendnat = _b[timet]*(timet-4)+f180 if e(sample)
sum relf1trendnat

   lab def fips 2 "AK"
   lab def fips 1 "AL", add
   lab def fips 05 "AR", add                       
   lab def fips 60 "AS", add             
   lab def fips 04 "AZ", add             
   lab def fips 06 "CA", add             
   lab def fips 08 "CO", add             
   lab def fips 09 "CT", add             
   lab def fips 11 "DC", add             
   lab def fips 10 "DE", add             
   lab def fips 12 "FL", add             
   lab def fips 13 "GA", add             
   lab def fips 66 "GU", add             
   lab def fips 15 "HI", add             
   lab def fips 19 "IA", add             
   lab def fips 16 "ID", add             
   lab def fips 17 "IL", add             
   lab def fips 18 "IN", add             
   lab def fips 20 "KS", add             
   lab def fips 21 "KY", add             
   lab def fips 22 "LA", add             
   lab def fips 25 "MA", add             
   lab def fips 24 "MD", add             
   lab def fips 23 "ME", add             
   lab def fips 26 "MI", add             
   lab def fips 27 "MN", add             
   lab def fips 29 "MO", add             
   lab def fips 28 "MS", add             
   lab def fips 30 "MT", add             
   lab def fips 37 "NC", add             
   lab def fips 38 "ND", add             
   lab def fips 31 "NE", add             
   lab def fips 33 "NH", add             
   lab def fips 34 "NJ", add             
   lab def fips 35 "NM", add             
   lab def fips 32 "NV", add             
   lab def fips 36 "NY", add             
   lab def fips 39 "OH", add             
   lab def fips 40 "OK", add             
   lab def fips 41 "OR", add             
   lab def fips 42 "PA", add             
   lab def fips 72 "PR", add             
   lab def fips 44 "RI", add             
   lab def fips 45 "SC", add             
   lab def fips 46 "SD", add             
   lab def fips 47 "TN", add             
   lab def fips 48 "TX", add             
   lab def fips 49 "UT", add             
   lab def fips 51 "VA", add             
   lab def fips 78 "VI", add             
   lab def fips 50 "VT", add             
   lab def fips 53 "WA", add             
   lab def fips 55 "WI", add             
   lab def fips 54 "WV", add             
   lab def fips 56 "WY", add          
   lab def fips 0  "US", add
lab val state fips

save Output/stateregs, replace
* this loop estimates the trend for each measure of fluidity and covariate
foreach V of var f1 owner p9010 age64p age1822 age2334  age3544 age4564  primemale primefemale en eu ue ne empchange migstate jcr jdr mfg ag retail fire serv gov selfemp manprof techocc servocc prodocc opocc adminocc salesocc military lths hsdeg somecol collplus married single union {
   quietly for num 1/2 4/6 8/13 15/42 44/51 53/56: reg `V' stateur stateur1 timet if state==X \ replace `V'trend = _b[timet] if state==X
}
foreach V of var f1  en eu ue ne empchange migstate jcr jdr {
   quietly for num 1/2 4/6 8/13 15/42 44/51 53/56: reg `V' stateur stateur1 timet if state==X & year>=1998 \ replace `V'trend98 = _b[timet] if state==X
}

* this section examines whether the trends in each variable are different in the first half and second half of the sample
quietly for any f1 en eu ue ne empchange migstate jcr jdr union age3544: gen Xtrendfh = . \ gen Xtrendsh = .\ gen Xtrendse = .
foreach V of var f1 en eu ue ne empchange migstate jcr jdr union age3544 {
   quietly for num 1/2 4/6 8/13 15/42 44/51 53/56: reg `V' stateur stateur1 timet timet97 y9713 if state==X \ replace `V'trendfh = _b[timet] if state==X\ replace `V'trendsh = _b[timet]+_b[timet97] if state==X \ replace `V'trendse = _se[timet97] if state==X
}
quietly for any en eu ue ne empchange migstate jcr jdr: gen Xtemp = 1 if abs((Xtrendsh-Xtrendfh)/Xtrendse)>=1.97 & Xtrendsh~=. & abs(Xtrendsh/Xtrendfh)>=.5
quietly for any en eu ue ne empchange migstate jcr jdr: replace Xtemp = 0 if (abs((Xtrendsh-Xtrendfh)/Xtrendse)<1.97 & Xtrendsh~=.) |  abs(Xtrendsh/Xtrendfh)<.5
sum entemp eutemp uetemp netemp empchangetemp migstatetemp jcrtemp jdrtemp if year==2000
drop *temp


* SHRM membership
merge 1:1 state year using Input/state_hr_rate_Stata13
gen hrtrend = .
quietly for num 1/2 4/6 8/13 15/42 44/51 53/56: reg hr_rate stateur stateur1 timet if state==X \ replace hrtrend = _b[timet] if state==X


gen avgtrend = 1/8*(netrend+entrend+uetrend+eutrend+empchangetrend+migstatetrend+jcrtrend+jdrtrend)
gen avgtrend98 = 1/8*(netrend98+entrend98+uetrend98+eutrend98+empchangetrend98+migstatetrend98+jcrtrend98+jdrtrend98)

* combine trends in each measure of fluidity
factor entrend eutrend uetrend netrend empchangetrend migstatetrend jcrtrend jdrtrend if year==2000
predict f1ptrend if e(sample)
mat f1pmat = r(scoef)
scalar f1psum = f1pmat[1,1]+f1pmat[2,1]+f1pmat[3,1]+f1pmat[4,1]+f1pmat[5,1]+f1pmat[6,1]+f1pmat[7,1]+f1pmat[8,1]
gen f1pmean = (f1pmat[1,1]*en+f1pmat[2,1]*eu+f1pmat[3,1]*ue+f1pmat[4,1]*ne+f1pmat[5,1]*empchange+f1pmat[6,1]*migstate+f1pmat[7,1]*jcr+f1pmat[8,1]*jdr)/f1psum
gen f1ptrendmean = (f1pmat[1,1]*entrend+f1pmat[2,1]*eutrend+f1pmat[3,1]*uetrend+f1pmat[4,1]*netrend+f1pmat[5,1]*empchangetrend+f1pmat[6,1]*migstatetrend+f1pmat[7,1]*jcrtrend+f1pmat[8,1]*jdrtrend)/f1psum
gen temp =  f1pmean if year==1980
egen f1pmean80 = mean(temp), by(state)
drop temp
factor entrend98 eutrend98 uetrend98 netrend98 empchangetrend98 migstatetrend98 jcrtrend98 jdrtrend98 if year==2000
predict f1ptrend98 if e(sample)
mat f1pmat98 = r(scoef)
scalar f1p98sum = f1pmat98[1,1]+f1pmat98[2,1]+f1pmat98[3,1]+f1pmat98[4,1]+f1pmat98[5,1]+f1pmat98[6,1]+f1pmat98[7,1]+f1pmat98[8,1]
gen f1p98mean = (f1pmat98[1,1]*en+f1pmat98[2,1]*eu+f1pmat98[3,1]*ue+f1pmat98[4,1]*ne+f1pmat98[5,1]*empchange+f1pmat98[6,1]*migstate+f1pmat98[7,1]*jcr+f1pmat98[8,1]*jdr)/f1p98sum
gen f1ptrend98mean = (f1pmat98[1,1]*entrend98+f1pmat98[2,1]*eutrend98+f1pmat98[3,1]*uetrend98+f1pmat98[4,1]*netrend98+f1pmat98[5,1]*empchangetrend98+f1pmat98[6,1]*migstatetrend98+f1pmat98[7,1]*jcrtrend98+f1pmat98[8,1]*jdrtrend98)/f1p98sum
gen temp =  f1p98mean if year==1998
egen f1p98mean98 = mean(temp), by(state)
drop temp

* correlation of combined trends in first half vs second half
factor entrendfh eutrendfh uetrendfh netrendfh empchangetrendfh migstatetrendfh jcrtrendfh jdrtrendfh if year==2000
predict f1ptrendfh if e(sample)
factor entrendsh eutrendsh uetrendsh netrendsh empchangetrendsh migstatetrendsh jcrtrendsh jdrtrendsh if year==2000
predict f1ptrendsh if e(sample)
corr f1ptrend f1ptrendfh f1ptrendsh if year==2000
corr f1ptrend f1ptrendfh f1ptrendsh if year==2000 & state~=2
lab var f1ptrendfh "Trend in Fluidity 1980-1996"
gr7 f1ptrendsh f1ptrendfh f1ptrendfh if year==2000, s([state].) c(.l) key1("") key2("") saving(Output/temp, replace) l1("Trend in Fluidity 1997-2013")



* bar chart of state trends 
gen relf1ptrend = f1ptrendmean/f1pmean80 if year==2000
gen relf1ptrend98 = f1ptrend98mean/f1p98mean98 if year==2000
sum relf1ptrend [w=mpop]
graph bar (mean) relf1ptrend if year==2000, over(state, sort(relf1ptrend) label(labsize(vsmall) alt)) l1("") ytitle("Trend in Labor Market Fluidity") graphregion(color(white)) ylab(, nogrid) yline(0, lc(black) lp(solid)) yline(-0.0106, lc(black) lp(dash)) saving(Output/Figure_6/statefig, replace) text(-.0112 75 "National Average", size(small))

gen dlpop = log(pop10/pop60)
gen ddlpop = log(pop10/pop00) - log(pop70/pop60)

gen decade = 1 if year>=1977 & year<=1979
replace decade = 2 if year>=1980 & year<=1989
replace decade = 3 if year>=1990 & year<=1999
replace decade = 4 if year>=2000 & year<=2014
quietly for var f1 age* lths hsdeg somecol collplus married single female mfg retail fire serv ag gov selfemp manprof techocc servocc prodocc opocc adminocc salesocc military inschool owner p9010 union primemale primefemale: egen mX = mean(X), by(state decade)
quietly for var age* lths hsdeg somecol collplus married single female mfg retail fire serv ag gov selfemp  manprof techocc servocc prodocc opocc adminocc salesocc military inschool owner p9010 union: gen temp = mX if year==1989 \ egen mX80s = mean(temp), by(state) \ drop temp
quietly for var age* lths hsdeg somecol collplus married single female mfg retail fire serv ag gov selfemp manprof techocc servocc prodocc opocc adminocc salesocc military owner p9010 union primemale primefemale: gen temp = mX if year>=1977 & year<=1979 \ egen mX70s = mean(temp), by(state) \ drop temp
quietly for var f1trend  f1ptrend f1trend98 f1ptrend98 f1ptrendfh f1ptrendsh mmfg70s mretail70s mfire70s mserv70s mag70s mage182270s mage233470s mage354470s mage456470s mage64p70s mmanprof70s mtechocc70s mservocc70s mprodocc70s mopocc70s madminocc70s msalesocc70s manproftrend techocctrend servocctrend prodocctrend opocctrend adminocctrend salesocctrend mlths70s mhsdeg70s msomecol70s mcollplus70s mowner70s mp901070s age1822trend age2334trend age3544trend age4564trend age64ptrend ownertrend p9010trend mfgtrend agtrend retailtrend firetrend servtrend lthstrend hsdegtrend somecoltrend collplustrend mmarried70s msingle70s marriedtrend singletrend munion70s uniontrend mgov70s govtrend mselfemp70s selfemptrend mprimemale70s mprimefemale70s primemaletrend primefemaletrend mmilitary70s militarytrend uniontrendfh uniontrendsh age3544trendfh age3544trendsh dlpop ddlpop:  sum X if year==2000 \ gen Xd = (X-r(mean))/r(sd)

lab var mage182270sd "% Age 18-22, 1977-79"
lab var age1822trendd "% Age 18-22, trend"
lab var mage233470sd "% Age 23-34, 1977-79"
lab var age2334trendd "% Age 23-34, trend"
lab var mage354470sd "% Age 35-44, 1977-79"
lab var age3544trendd "% Age 35-44, trend"
lab var mage456470sd "% Age 45-64, 1977-79"
lab var age4564trendd "% Age 45-64, trend"
lab var mage64p70sd "% Age 64+, 1977-79"
lab var age64ptrendd "% Age 64+, trend"
lab var mmfg70sd "% Manufacturing, 1977-79"
lab var mfgtrendd "% Manufacturing, trend"
lab var mretail70sd "% Retail, 1977-79"
lab var retailtrendd "% Retail, trend"
lab var mfire70sd "% FIRE, 1977-79"
lab var firetrendd "% FIRE, trend"
lab var mserv70sd "% Service, 1977-79"
lab var servtrendd "% Service, trend"
lab var mag70sd "% Agriculture, 1977-79"
lab var agtrendd "% Agriculture, trend"
lab var mlths70sd "% Less than High School, 1977-79"
lab var lthstrendd "% Less than High School, trend"
lab var msomecol70sd "% Some College, 1977-79"
lab var somecoltrendd "% Some College, trend"
lab var mcollplus70sd "% College Plus, 1977-79"
lab var collplustrendd "% College Plus, trend"
lab var mmarried70sd "% Married, 1977-79"
lab var marriedtrendd "% Married, trend"
lab var msingle70sd "% Single (never married), 1977-79"
lab var singletrendd "% Single (never married), trend"
lab var mowner70sd "% Homeowner, 1977-79"
lab var ownertrendd "% Homeowner, trend"
lab var munion70sd "% Union member, 1977-79"
lab var uniontrendd "% Union member, trend"
lab var mselfemp70sd "% Self Employed, 1977-79"
lab var selfemptrendd "% Self Employed, trend"
lab var mgov70sd "% Government worker, 1977-79"
lab var govtrendd "% Government worker, trend"
lab var mmanprof70sd "% Manag./prof. occ., 1977-79"
lab var manproftrendd "% Manag./prof. occ., trend"
lab var mtechocc70sd "% Technicians, 1977-79"
lab var techocctrendd "% Technicians, trend"
lab var mprodocc70sd "% Production/craft occupation, 1977-79"
lab var prodocctrendd "% Production/craft occupation, trend"
lab var mopocc70sd "% Operator occupation, 1977-79"
lab var opocctrendd "% Operator occupation, trend"
lab var madminocc70sd "% Admin. support occ., 1977-79"
lab var adminocctrendd "% Admin. support occ., trend"
lab var mservocc70sd "% Service occupation, 1977-79"
lab var servocctrendd "% Service occupation, trend"
lab var msalesocc70sd "% Sales occupation, 1977-79"
lab var salesocctrendd "% Sales occupation, trend"


lab var cendiv1 "New England division"
lab var cendiv2 "Middle Atlantic division"
lab var cendiv3 "East North Central division"
lab var cendiv4 "West North Central division"
lab var cendiv5 "South Atlantic division"
lab var cendiv6 "East South Central division"
lab var cendiv7 "West South Central division"
lab var cendiv8 "Mountain division"
lab var cendiv9 "Pacific division"


* correlation of trend with various state characteristics
reg f1ptrendd mmfg70sd mretail70sd mfire70sd mserv70sd mag70sd  mfgtrendd retailtrendd firetrendd servtrendd agtrendd if year==2000
estimates store indmod
reg f1ptrendd mage182270sd mage233470sd mage354470sd mage456470sd mage64p70sd age1822trendd age2334trendd age3544trendd age4564trendd age64ptrendd if year==2000
estimates store agemod
reg f1ptrendd mlths70sd msomecol70sd mcollplus70sd lthstrendd somecoltrendd collplustrendd if year==2000
estimates store edmod
reg f1ptrendd mmanprof70sd mtechocc70sd mservocc70sd mprodocc70sd mopocc70sd msalesocc70sd madminocc70sd manproftrendd techocctrendd servocctrendd prodocctrendd opocctrendd salesocctrendd adminocctrendd if year==2000
estimates store occmod
reg f1ptrendd mowner70sd ownertrendd if year==2000
estimates store ownermod
reg f1ptrendd munion70sd uniontrendd if year==2000
estimates store unionmod
reg f1ptrendd mselfemp70sd selfemptrendd mgov70sd govtrendd if year==2000
estimates store selfempmod 
reg f1ptrendd mp901070s p9010trendd if year==2000
reg f1ptrendd mmarried70sd marriedtrendd msingle70sd singletrendd if year==2000
estimates store maritalmod
reg f1ptrendd cendiv1-cendiv9 if year==2000, noc
estimates store divmod


reg f1ptrendd mmfg70sd mserv70sd mage456470sd age1822trendd age3544trendd p9010trendd mmarried70sd msomecol70sd collplustrendd mselfemp70sd  mgov70sd uniontrendd mtechocc70sd madminocc70sd mopocc70sd msalesocc70sd manproftrendd salesocctrendd if year==2000
reg f1ptrendd mmfg70sd age3544trendd mmarried70sd uniontrendd  cendiv1-cendiv9 if year==2000, noc
reg f1ptrendd madminocc70sd mopocc70sd uniontrendd age3544trendd  cendiv2 cendiv8 cendiv9 if year==2000
estimates store finalmod
reg f1ptrendd madminocc70sd mopocc70sd uniontrendd age3544trendd  cendiv2 cendiv8 cendiv9 if year==2000 & state~=2
estimates store finalmodx2
reg f1ptrendd madminocc70sd mopocc70sd uniontrendd age3544trendd  cendiv2 cendiv8 cendiv9 dlpopd if year==2000
reg f1ptrendd madminocc70sd mopocc70sd uniontrendd age3544trendd  cendiv2 cendiv8 cendiv9 ddlpopd if year==2000

* Table A.6
estout agemod edmod maritalmod ownermod indmod occmod unionmod selfempmod divmod, label collab(none) mlab("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)")drop(_cons) modelwidth(5) varwidth(35) cells(b(star fmt(2))) starlevels(+ 0.10 * 0.05) stats(N r2_a, fmt(%15.0f %15.2f) labels("# Obs." "Adj. R-squared"))  legend
* Table 4
estout finalmod finalmodx2, label collab(none) mlab("All States" "Excl. AK") varlab(_cons "Constant") modelwidth(15) varwidth(30) cells(b(star fmt(2)) se(par fmt(2))) starlevels(+ 0.10 * 0.05 ** 0.01) stats(N r2_a, fmt(%15.0f %15.2f)labels("# Obs." "Adj. R-squared"))    legend


* correlation of trend with SHRM membership
quietly for var avgtrend98 netrend98 entrend98 uetrend98 eutrend98 empchangetrend98 migstatetrend98 jcrtrend98 jdrtrend98 avgtrend netrend entrend uetrend eutrend empchangetrend migstatetrend jcrtrend jdrtrend wharton : sum X if year==2000 \ gen Xd = (X-r(mean))/r(sd)
quietly for var hrtrend : sum X if year==2000 & state~=11 \ gen Xd = (X-r(mean))/r(sd)
for any f1p avg ne en ue eu empchange migstate jcr jdr : reg Xtrend98d hrtrendd if year==2000 & state~=11 \ estimates store Xmodhr \ reg Xtrend98d hrtrendd madminocc70sd mopocc70sd uniontrendd age3544trendd cendiv2 cendiv8 cendiv9 if year==2000 & state~=11 \ estimates store Xmodhrb
reg f1ptrendd hrtrendd if year==2000 & state~=11
reg f1ptrendd hrtrendd madminocc70sd mopocc70sd uniontrendd age3544trendd cendiv2 cendiv8 cendiv9 if year==2000 & state~=11
estout f1pmodhr avgmodhr nemodhr enmodhr uemodhr eumodhr empchangemodhr migstatemodhr jcrmodhr jdrmodhr, keep(hrtrendd) cells(b(star fmt(2)) se(par fmt(2))) stats(N r2_a, fmt(%15.0f %15.2f)) 
estout f1pmodhrb avgmodhrb nemodhrb enmodhrb uemodhrb eumodhrb empchangemodhrb migstatemodhrb jcrmodhrb jdrmodhrb, keep(hrtrendd) cells(b(star fmt(2)) se(par fmt(2))) stats(N r2_a, fmt(%15.0f %15.2f)) 

* correlation of trend with land use regulation
for any f1p avg ne en ue eu empchange migstate jcr jdr: reg Xtrendd whartond if year==2000 \ estimates store Xmodreg \ reg Xtrendd whartond madminocc70sd mopocc70sd uniontrendd age3544trendd cendiv2 cendiv8 cendiv9 if year==2000  \ estimates store Xmodregb
estout f1pmodreg avgmodreg nemodreg enmodreg uemodreg eumodreg empchangemodreg migstatemodreg jcrmodreg jdrmodreg, keep(whartond) cells(b(star fmt(2)) se(par fmt(2))) stats(N r2_a, fmt(%15.0f %15.2f)) 
estout f1pmodregb avgmodregb nemodregb enmodregb uemodregb eumodregb empchangemodregb migstatemodregb jcrmodregb jdrmodregb, keep(whartond) cells(b(star fmt(2)) se(par fmt(2))) stats(N r2_a, fmt(%15.0f %15.2f)) 



* graph of trend in HR rate and trend in fluidity
gr7  f1ptrend98 hrtrend if year==2000 , s([state]) ylab(-.15(.03)0) xlab(0.00004(.00004).00024)
gr7  relf1ptrend98 hrtrend if year==2000 & state~=11 , s([state]) ylab(-.018(.003)0.006) xlab(0.00004(.00001).0001) l1("Trend in Labor Market Fluidity 1998-2013") b2("Trend in Human Resource Membership 1998-2013") saving(Output\Figure_12\hrfig, replace)

* graph of Wharton regulation index and trend in fluidity
gr7  relf1ptrend wharton if year==2000 & state~=11 , s([state]) ylab(-.024(.003)-.003) xlab(-1.2(.4)2.4)  l1("Trend in Labor Market Fluidity") b2("Land Use Regulation") saving(Output\Figure_10\regfig, replace)

outfile state relf1ptrend98 hrtrend  if year==2000 & state~=11 using Output\Figure_12\hrfig.csv, comma wide replace nolab
outfile state relf1ptrend wharton  if year==2000 & state~=11 using Output\Figure_10\regfig.csv, comma wide replace nolab

quietly log close

