***takes extracted cps data from match_extract.do
***Note: modified from code on Rob Shimer's website

local first=197601
while `first' <=201507  {
local second = `first' + 1
if (`first'-12)/100 == int((`first'-12)/100) {
   local second = `first' + 89
}
if `second' != 197801 & `second' != 198507 & `second' != 198510 & `second' != 199401 & `second' != 199506 & `second' != 199507 & `second' != 199508 & `second' != 199509 {

clear
use mcr/scratch-m1cls01/data/cps/matching/cps`second'.dta
drop if mis==1 | mis == 5
local count2 = _N
rename mis mis1
rename educ educ1
rename status status1
rename fweight fweight1
rename mar mar1
rename dur dur1
rename ind ind1
rename occu occu1
rename state state1
gen mis0 = mis1 - 1
sort hh line race sex age mis0
quietly by hh line race sex age mis0: gen dup = cond(_N==1,0,_n)
    *** Flag any duplicate records so none of them can be matched.
sort hh line race sex age mis0 dup
save mcr/scratch-m1cls01/data/cps/matching/`second', replace

clear
use mcr/scratch-m1cls01/data/cps/matching/cps`first'
drop if mis == 4 | mis == 8
local count1 = _N
rename mis mis0
rename educ educ0
rename status status0
rename fweight fweight0
rename mar mar0
rename dur dur0
rename ind ind0
rename occu occu0
rename state state0
sort hh line race sex age mis0
quietly by hh line race sex age mis0: gen dup = cond(_N==1,0,0-_n)
   *** Flag any duplicate records with a negative number so none of them can be matched
sort hh line race sex age mis0 dup
merge hh line race sex age mis0 dup using mcr/scratch-m1cls01/data/cps/matching/`second'
rename _merge _merge1
save mcr/scratch-m1cls01/data/cps/matching/merg`second'.dta, replace
   *** This creates a record of all individuals, matched if they agree on hh, line, race, sex, and exactly on age. And also neither record can be duplicated.
erase mcr/scratch-m1cls01/data/cps/matching/`second'.dta
keep if _merge1 == 2
replace age = age - 1
sort hh line race sex age mis0 dup
save mcr/scratch-m1cls01/data/cps/matching/touse, replace
clear
use mcr/scratch-m1cls01/data/cps/matching/merg`second'
keep if _merge1 == 1
sort hh line race sex age mis0 dup
merge hh line race sex age mis0 dup using mcr/scratch-m1cls01/data/cps/matching/touse, update
drop if _merge == 1 | _merge == 2
   *** So now we have a data set with individuals whose age was off by one year
   *** We expect _merge == 5 because of the mismatched values llind, z, lweight
erase mcr/scratch-m1cls01/data/cps/matching/touse.dta
append using mcr/scratch-m1cls01/data/cps/matching/merg`second'
   *** This is a combined data set

sort hh line race sex age mis0 dup _merge
quietly by hh line race sex age mis0 dup: gen dup1 = cond(_N==1,0,_n)
drop if dup1 > 0 & _merge != 5
drop dup1
   *** All the records that were matched by allowing for age changes are now duplicated.
   *** First drop the ones with the younger age.
replace age = age+1 if _merge == 5
sort hh line race sex age mis0 dup _merge
quietly by hh line race sex age mis0 dup: gen dup1 = cond(_N==1,0,_n)
drop if dup1 > 0 & _merge != 5
   *** Then drop the ones with the older age.
drop dup1
replace _merge1 = 3 if _merge == 5
   *** Records that were merged with age off by one year now count as merged.
save mcr/scratch-m1cls01/data/cps/matching/merg`second', replace

gen count1 = 1 if _merge1 == 1 | _merge1 == 3
gen count2 = 1 if _merge1 == 2 | _merge1 == 3
sum count1 count2
display `count1'
display `count2'
}
local first=`second'
}
