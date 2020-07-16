* analysis of trends by state for 35 to 64 year olds
set trace off
set more 1 
capture log close
clear
set linesize 250

log using stateregs3564.log, replace

* flows from Unicon by age
use Input/state-age-level-data, clear
replace migstate = . if year==1984 | year<=1979
keep if ageg==3
keep year empchange migstate statefip en eu ue ne
rename statefip state

cd ../CPS_Data_Setup/.

*merge 1:1 state year using ipums3564
merge 1:1 state year using Output/ipums3564
drop _merge
* extend Unicon data with ipums
sort state year
quietly for var smigrant empchangeipums: quietly by state: gen X1 = X[_n+1]
quietly by state: replace migstate = migstate[_n-1]*smigrant1/smigrant1[_n-1] if year>=2013
quietly by state: replace empchange = empchange[_n-1]*empchangeipums1/empchangeipums1[_n-1] if year>=2013
*merge 1:1 state year using cpscovariates
merge 1:1 state year using Output/cpscovariates
drop empchangeipums* smigrant*
drop _merge

cd ../Table_4_A6_Fig_6_10_12/.

*merge 1:1 state year using union
merge 1:1 state year using Output/union
drop if _merge==2
drop _merge

*merge 1:1 state year using stateur
merge 1:1 state year using Input/stateur
drop _merge

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

gen timet = 1 if year==1978
sort state year
quietly by state: replace timet = timet[_n-1]+1 if year>=1979
gen timet2 = timet^2
quietly for num 1/3: quietly by state: gen stateurX = stateur[_n-X]
quietly for var age2334  en eu ue ne empchange migstate owner age3544 union: gen Xtrend = .

foreach V of var age2334  age3544 en eu ue ne empchange migstate owner age3544 union {
    quietly for num 1/2 4/6 8/13 15/42 44/51 53/56: reg `V' stateur stateur1 timet if state==X \ replace `V'trend = _b[timet] if state==X
}
gen avgtrend = 1/6*(entrend+eutrend+uetrend+netrend+empchangetrend+migstatetrend)

factor entrend eutrend uetrend netrend empchangetrend migstatetrend if year==2000
predict f1ptrend if e(sample)
mat f1pmat = r(scoef)
scalar f1psum = f1pmat[1,1]+f1pmat[2,1]+f1pmat[3,1]+f1pmat[4,1]+f1pmat[5,1]+f1pmat[6,1]
gen f1pmean = (f1pmat[1,1]*en+f1pmat[2,1]*eu+f1pmat[3,1]*ue+f1pmat[4,1]*ne+f1pmat[5,1]*empchange+f1pmat[6,1]*migstate)/f1psum
gen f1ptrendmean = (f1pmat[1,1]*entrend+f1pmat[2,1]*eutrend+f1pmat[3,1]*uetrend+f1pmat[4,1]*netrend+f1pmat[5,1]*empchangetrend+f1pmat[6,1]*migstatetrend)/f1psum
gen temp =  f1pmean if year==1980
egen f1pmean80 = mean(temp), by(state)
drop temp
gen relf1ptrend = f1ptrendmean/f1pmean80 if year==2000

egen mpop = mean(pop), by(state)
replace mpop = round(mpop,1)

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

cd ../Figure_7/.

gen decade = 1 if year>=1977 & year<=1979
replace decade = 2 if year>=1980 & year<=1989
replace decade = 3 if year>=1990 & year<=1999
replace decade = 4 if year>=2000 & year<=2014
quietly for var en eu ue ne empchange migstate age* lths hsdeg somecol collplus married single female mfg serv ag manprof techocc servocc prodocc military inschool owner adminocc opocc: egen mX = mean(X), by(state decade)
quietly for var age* lths hsdeg somecol collplus married single female mfg serv ag manprof techocc servocc prodocc military inschool owner adminocc opocc : gen temp = mX if year==1989 \ egen mX80s = mean(temp), by(state) \ drop temp
quietly for var age* lths hsdeg somecol collplus married single female mfg serv ag manprof techocc servocc prodocc military inschool owner adminocc opocc : gen temp = mX if year>=1977 & year<=1979 \ egen mX70s = mean(temp), by(state) \ drop temp
lab var f1ptrend "1st Factor of Fluidity Trends, Age 35-64"
lab var age2334trend "Trend in Age 23-34"
* graph of trend in fluidity and trend in youth share
gr7 relf1ptrend age2334trend if year==2000, s([state]) ylab(-0.015(.003).009) xlab(-0.003(.0005).0005)   l1("Trend in Labor Market Fluidity Age 35-64")  saving(Output/agecorr, replace)
outfile state relf1ptrend age2334trend if year==2000 using Output/agefig.csv, comma wide replace nolab

reg f1ptrend age2334trend if year==2000
quietly for var f1ptrend age2334trend avgtrend netrend entrend uetrend eutrend empchangetrend migstatetrend uniontrend age3544trend madminocc70s mopocc70s: sum X if year==2000 \ gen Xd = (X-r(mean))/r(sd)
reg f1ptrendd age2334trendd if year==2000
reg f1ptrendd  age2334trendd age3544trendd madminocc70sd mopocc70sd uniontrendd  cendiv2 cendiv8 cendiv9 if year==2000
reg f1ptrendd  age2334trendd madminocc70sd mopocc70sd uniontrendd  cendiv2 cendiv8 cendiv9 if year==2000
reg f1ptrendd  age2334trendd madminocc70sd mopocc70sd uniontrendd  cendiv2 cendiv8 cendiv9 if year==2000 & state~=2
reg f1ptrendd  age2334trendd age3544trendd madminocc70sd mopocc70sd uniontrendd  cendiv2 cendiv8 cendiv9 if year==2000 & state~=2
corr age2334trend age3544trend if year==2000

for any f1p avg ne en ue eu empchange migstate: reg Xtrendd age2334trendd if year==2000 \ estimates store Xmod \ reg Xtrendd age2334trendd madminocc70sd mopocc70sd uniontrendd cendiv2 cendiv8 cendiv9 if year==2000  \ estimates store Xmodb
estout f1pmod avgmod nemod enmod uemod eumod empchangemod migstatemod , keep(age2334trendd) cells(b(star fmt(2)) se(par fmt(2))) stats(N r2_a, fmt(%15.0f %15.2f)) 
estout f1pmodb avgmodb nemodb enmodb uemodb eumodb empchangemodb migstatemodb , keep(age2334trendd) cells(b(star fmt(2)) se(par fmt(2))) stats(N r2_a, fmt(%15.0f %15.2f)) 



quietly log close

