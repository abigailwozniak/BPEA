***for extracting variables from raw CPS data
***Note: modified from code on Rob Shimer's website

local x=201404

while `x' <=197712 {
clear
!cp mcr/data_labor/cps/basic/raw/all/cpsb`x'.gz research/brookings-dynamism/dta/matching/cpsb`x'.gz
!gunzip research/brookings-dynamism/dta/matching/cpsb`x'.gz 
!mv research/brookings-dynamism/dta/matching/cpsb`x' research/brookings-dynamism/dta/matching/cpsb`x'.raw
!chmod o-rwx research/brookings-dynamism/dta/matching/cpsb`x'.raw
infix hh 4-8 hh1 9-12 hh2 25-26 line 94-95 mis 2 age 97-98 race 100 sex 101 status 109 str dur 66-67 double fweight 121-132 educ 103-104 grade 105 mar 99 str ind 88-90 str occu 91-93 state 17-18 using research/brookings-dynamism/dta/matching/cpsb`x'
generate double hh3 = hh*1000000+hh1*100+hh2
generate educ1 = educ-grade+1
drop hh hh1 hh2 educ
rename hh3 hh
rename educ1 educ
replace dur =" ." if dur =="--"
replace ind ="." if ind =="---"
replace occu ="." if occu =="---"

compress
save mcr/scratch-m1cls01/data/cps/matching/cps`x'.dta, replace
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'.raw
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

while `x' <=198212 {
clear
!cp mcr/data_labor/cps/basic/raw/all/cpsb`x'.gz research/brookings-dynamism/dta/matching/cpsb`x'.gz
!gunzip research/brookings-dynamism/dta/matching/cpsb`x'.gz 
!mv research/brookings-dynamism/dta/matching/cpsb`x' research/brookings-dynamism/dta/matching/cpsb`x'.raw
!chmod o-rwx research/brookings-dynamism/dta/matching/cpsb`x'.raw
infix double hh 4-15 line 94-95 mis 2 age 97-98 race 100 sex 101 status 109 str dur 66-67 double fweight 121-132 educ 103-104 grade 105 mar 99 str ind 88-90 str occu 91-93 state 17-18 using research/brookings-dynamism/dta/matching/cpsb`x'
generate educ1 = educ-grade+1
drop educ
rename educ1 educ
replace dur =" ." if dur =="--"
replace ind ="." if ind =="---"
replace occu ="." if occu =="---"

compress
save mcr/scratch-m1cls01/data/cps/matching/cps`x'.dta, replace
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'.raw
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

while `x' <=198312 {
clear
!cp mcr/data_labor/cps/basic/raw/all/cpsb`x'.gz research/brookings-dynamism/dta/matching/cpsb`x'.gz
!gunzip research/brookings-dynamism/dta/matching/cpsb`x'.gz 
!mv research/brookings-dynamism/dta/matching/cpsb`x' research/brookings-dynamism/dta/matching/cpsb`x'.raw
!chmod o-rwx research/brookings-dynamism/dta/matching/cpsb`x'.raw
infix  double hh 4-15 line 94-95 mis 2 age 97-98 race 100 sex 101 status 109 str dur 66-67 double fweight 121-132 educ 103-104 grade 105 mar 99 str ind 524-526 str occu 527-529 state 17-18 using research/brookings-dynamism/dta/matching/cpsb`x'
generate educ1 = educ-grade+1
drop educ
rename educ1 educ
replace dur="." if dur=="--"
replace ind="." if ind=="---"
replace occu="." if occu=="---"

compress
save mcr/scratch-m1cls01/data/cps/matching/cps`x'.dta, replace
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'.raw
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

while `x' <=198812 {
clear
!cp mcr/data_labor/cps/basic/raw/all/cpsb`x'.gz research/brookings-dynamism/dta/matching/cpsb`x'.gz
!gunzip research/brookings-dynamism/dta/matching/cpsb`x'.gz 
!mv research/brookings-dynamism/dta/matching/cpsb`x' research/brookings-dynamism/dta/matching/cpsb`x'.raw
!chmod o-rwx research/brookings-dynamism/dta/matching/cpsb`x'.raw
infix  double hh 4-15 line 541-542 mis 2 age 97-98 race 100 sex 101 status 109 str dur 66-67 double fweight 121-132 educ 103-104 grade 105 mar 99 str ind 524-526 str occu 527-529 state 17-18 using research/brookings-dynamism/dta/matching/cpsb`x'
generate educ1 = educ-grade+1
drop educ
rename educ1 educ
replace dur="." if dur=="--"
replace ind="." if ind=="---"
replace occu="." if occu=="---"

compress
save mcr/scratch-m1cls01/data/cps/matching/cps`x'.dta, replace
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'.raw
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

while `x' <=199112 {
clear
!cp mcr/data_labor/cps/basic/raw/all/cpsb`x'.gz research/brookings-dynamism/dta/matching/cpsb`x'.gz
!gunzip research/brookings-dynamism/dta/matching/cpsb`x'.gz 
!mv research/brookings-dynamism/dta/matching/cpsb`x' research/brookings-dynamism/dta/matching/cpsb`x'.raw
!chmod o-rwx research/brookings-dynamism/dta/matching/cpsb`x'.raw
infix  double hh 145-156 line 264-265 mis 70 age 270-271 race 280 sex 275 status 348 str dur 304-305 double fweight 398-405 double lweight 576-583 llind 584 educ 277-278 grade 279 mar 272 str ind 310-312 str occu 313-315 state 114-115 using research/brookings-dynamism/dta/matching/cpsb`x'
generate educ1 = educ-grade+1
drop educ
rename educ1 educ
replace dur="." if dur=="--"
replace ind="." if ind=="---"
replace occu="." if occu=="---"

compress
save mcr/scratch-m1cls01/data/cps/matching/cps`x'.dta, replace
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'.raw
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

while `x' <=199312 {
clear
!cp mcr/data_labor/cps/basic/raw/all/cpsb`x'.gz research/brookings-dynamism/dta/matching/cpsb`x'.gz
!gunzip research/brookings-dynamism/dta/matching/cpsb`x'.gz 
!mv research/brookings-dynamism/dta/matching/cpsb`x' research/brookings-dynamism/dta/matching/cpsb`x'.raw
!chmod o-rwx research/brookings-dynamism/dta/matching/cpsb`x'.raw
infix  double hh 145-156 line 264-265 mis 70 age 270-271 race 280 sex 275 status 348 str dur 304-305 double fweight 398-405 double lweight 576-583 llind 584 educ 277-278 mar 272 str ind 310-312 str occu 313-315 state 114-115 using research/brookings-dynamism/dta/matching/cpsb`x'
replace dur="." if dur=="--"
replace ind="." if ind=="---"
replace occu="." if occu=="---"

compress
save mcr/scratch-m1cls01/data/cps/matching/cps`x'.dta, replace
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'.raw
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

while `x' <=199505 {
clear
!cp mcr/data_labor/cps/basic/raw/all/cpsb`x'.gz research/brookings-dynamism/dta/matching/cpsb`x'.gz
!gunzip research/brookings-dynamism/dta/matching/cpsb`x'.gz 
!mv research/brookings-dynamism/dta/matching/cpsb`x' research/brookings-dynamism/dta/matching/cpsb`x'.raw
!chmod o-rwx research/brookings-dynamism/dta/matching/cpsb`x'.raw
infix gestfips 93-94 double hrhhid 1-12 str hrsersuf 75-76 line 147-148 mis 63-64 age 122-123 race 139-140 sex 129-130 status 180-181 str dur 407-409 double fweight 613-622 double lweight 593-602 llind 69-70 educ 137-138 mar 125-126 str ind 436-438 str occu 439-441 state 91-92 using research/brookings-dynamism/dta/matching/cpsb`x'
generate z=real(hrsersuf)
replace z=0 if hrsersuf=="-1"
replace z=1 if hrsersuf=="A"
replace z=2 if hrsersuf=="B"
replace z=3 if hrsersuf=="C"
replace z=4 if hrsersuf=="D"
replace z=5 if hrsersuf=="E"
replace z=6 if hrsersuf=="F"
replace z=7 if hrsersuf=="G"
replace z=8 if hrsersuf=="H"
replace z=9 if hrsersuf=="I"
replace z=10 if hrsersuf=="J"
replace z=11 if hrsersuf=="K"
replace z=12 if hrsersuf=="L"
replace z=13 if hrsersuf=="M"
replace z=14 if hrsersuf=="N"
replace z=15 if hrsersuf=="O"
replace z=16 if hrsersuf=="P"
replace z=17 if hrsersuf=="Q"
replace z=18 if hrsersuf=="R"
replace z=19 if hrsersuf=="S"
replace z=20 if hrsersuf=="T"
replace z=21 if hrsersuf=="U"
replace z=22 if hrsersuf=="V"
replace z=23 if hrsersuf=="W"
replace z=24 if hrsersuf=="X"
replace z=26 if hrsersuf=="Y"
replace z=25 if hrsersuf=="Z"
generate double hh=gestfips*100000000000000+hrhhid*100+z
replace dur="." if dur=="--"
replace ind="." if ind=="---"
replace occu="." if occu=="---"
drop hrhhid gestfips hrsersuf

compress
save mcr/scratch-m1cls01/data/cps/matching/cps`x'.dta, replace
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'.raw
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}


while `x' <=200212 {
clear
!cp mcr/data_labor/cps/basic/raw/all/cpsb`x'.gz research/brookings-dynamism/dta/matching/cpsb`x'.gz
!gunzip research/brookings-dynamism/dta/matching/cpsb`x'.gz 
!mv research/brookings-dynamism/dta/matching/cpsb`x' research/brookings-dynamism/dta/matching/cpsb`x'.raw
!chmod o-rwx research/brookings-dynamism/dta/matching/cpsb`x'.raw
infix double hrhhid 1-15 str hrsersuf 75-76 line 147-148 mis 63-64 age 122-123 race 139-140 sex 129-130 status 180-181 str dur 407-409 double fweight 613-622 double lweight 593-602 llind 69-70 educ 137-138 mar 125-126 str ind 436-438 str occu 439-441 state 91-92 using research/brookings-dynamism/dta/matching/cpsb`x'
generate z=real(hrsersuf)
replace z=0 if hrsersuf=="-1"
replace z=1 if hrsersuf=="A"
replace z=2 if hrsersuf=="B"
replace z=3 if hrsersuf=="C"
replace z=4 if hrsersuf=="D"
replace z=5 if hrsersuf=="E"
replace z=6 if hrsersuf=="F"
replace z=7 if hrsersuf=="G"
replace z=8 if hrsersuf=="H"
replace z=9 if hrsersuf=="I"
replace z=10 if hrsersuf=="J"
replace z=11 if hrsersuf=="K"
replace z=12 if hrsersuf=="L"
replace z=13 if hrsersuf=="M"
replace z=14 if hrsersuf=="N"
replace z=15 if hrsersuf=="O"
replace z=16 if hrsersuf=="P"
replace z=17 if hrsersuf=="Q"
replace z=18 if hrsersuf=="R"
replace z=19 if hrsersuf=="S"
replace z=20 if hrsersuf=="T"
replace z=21 if hrsersuf=="U"
replace z=22 if hrsersuf=="V"
replace z=23 if hrsersuf=="W"
replace z=24 if hrsersuf=="X"
replace z=26 if hrsersuf=="Y"
replace z=25 if hrsersuf=="Z"
generate double hh=hrhhid*100+z
replace dur="." if dur=="--"
replace ind="." if ind=="---"
replace occu="." if occu=="---"
drop hrhhid hrsersuf

compress
save mcr/scratch-m1cls01/data/cps/matching/cps`x'.dta, replace
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'.raw
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}


while `x' <=200501 {
clear
!cp mcr/data_labor/cps/basic/raw/all/cpsb`x'.gz research/brookings-dynamism/dta/matching/cpsb`x'.gz
!gunzip research/brookings-dynamism/dta/matching/cpsb`x'.gz 
!mv research/brookings-dynamism/dta/matching/cpsb`x' research/brookings-dynamism/dta/matching/cpsb`x'.raw
!chmod o-rwx research/brookings-dynamism/dta/matching/cpsb`x'.raw
infix double hrhhid 1-15 str hrsersuf 75-76 line 147-148 mis 63-64 age 122-123 race 139-140 sex 129-130 status 180-181 str dur 407-409 double fweight 613-622 double lweight 593-602 llind 69-70 educ 137-138 mar 125-126 str ind 856-859 str occu 860-863 state 91-92 using research/brookings-dynamism/dta/matching/cpsb`x'
generate z=real(hrsersuf)
replace z=0 if hrsersuf=="-1"
replace z=1 if hrsersuf=="A"
replace z=2 if hrsersuf=="B"
replace z=3 if hrsersuf=="C"
replace z=4 if hrsersuf=="D"
replace z=5 if hrsersuf=="E"
replace z=6 if hrsersuf=="F"
replace z=7 if hrsersuf=="G"
replace z=8 if hrsersuf=="H"
replace z=9 if hrsersuf=="I"
replace z=10 if hrsersuf=="J"
replace z=11 if hrsersuf=="K"
replace z=12 if hrsersuf=="L"
replace z=13 if hrsersuf=="M"
replace z=14 if hrsersuf=="N"
replace z=15 if hrsersuf=="O"
replace z=16 if hrsersuf=="P"
replace z=17 if hrsersuf=="Q"
replace z=18 if hrsersuf=="R"
replace z=19 if hrsersuf=="S"
replace z=20 if hrsersuf=="T"
replace z=21 if hrsersuf=="U"
replace z=22 if hrsersuf=="V"
replace z=23 if hrsersuf=="W"
replace z=24 if hrsersuf=="X"
replace z=26 if hrsersuf=="Y"
replace z=25 if hrsersuf=="Z"
generate double hh=hrhhid*100+z
replace dur="." if dur=="--"
replace ind="." if ind=="---"
replace occu="." if occu=="---"
drop hrhhid hrsersuf

compress
save mcr/scratch-m1cls01/data/cps/matching/cps`x'.dta, replace
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'.raw
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

while `x' <=201401 {
clear
!cp mcr/data_labor/cps/basic/raw/all/cpsb`x'.gz research/brookings-dynamism/dta/matching/cpsb`x'.gz
!gunzip research/brookings-dynamism/dta/matching/cpsb`x'.gz 
!mv research/brookings-dynamism/dta/matching/cpsb`x' research/brookings-dynamism/dta/matching/cpsb`x'.raw
!chmod o-rwx research/brookings-dynamism/dta/matching/cpsb`x'.raw
infix double hrhhid 1-15 str hrsersuf 75-76 line 147-148 mis 63-64 age 122-123 race 139-140 sex 129-130 status 180-181 str dur 407-409 double fweight 613-622 double lweight 593-602 llind 69-70 educ 137-138 mar 125-126 str ind 856-859 str occu 860-863 state 91-92 using research/brookings-dynamism/dta/matching/cpsb`x'
generate z=real(hrsersuf)
replace z=0 if hrsersuf=="-1"
replace z=1 if hrsersuf=="A"
replace z=2 if hrsersuf=="B"
replace z=3 if hrsersuf=="C"
replace z=4 if hrsersuf=="D"
replace z=5 if hrsersuf=="E"
replace z=6 if hrsersuf=="F"
replace z=7 if hrsersuf=="G"
replace z=8 if hrsersuf=="H"
replace z=9 if hrsersuf=="I"
replace z=10 if hrsersuf=="J"
replace z=11 if hrsersuf=="K"
replace z=12 if hrsersuf=="L"
replace z=13 if hrsersuf=="M"
replace z=14 if hrsersuf=="N"
replace z=15 if hrsersuf=="O"
replace z=16 if hrsersuf=="P"
replace z=17 if hrsersuf=="Q"
replace z=18 if hrsersuf=="R"
replace z=19 if hrsersuf=="S"
replace z=20 if hrsersuf=="T"
replace z=21 if hrsersuf=="U"
replace z=22 if hrsersuf=="V"
replace z=23 if hrsersuf=="W"
replace z=24 if hrsersuf=="X"
replace z=26 if hrsersuf=="Y"
replace z=25 if hrsersuf=="Z"
generate double hh=hrhhid*100+z
replace dur="." if dur=="--"
replace ind="." if ind=="---"
replace occu="." if occu=="---"
drop hrhhid hrsersuf

compress
save mcr/scratch-m1cls01/data/cps/matching/cps`x'.dta, replace
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'.raw
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

while `x' <=201403 {
clear
!cp mcr/data_labor/cps/basic/raw/all/cpsb`x'.gz research/brookings-dynamism/dta/matching/cpsb`x'.gz
!gunzip research/brookings-dynamism/dta/matching/cpsb`x'.gz 
!mv research/brookings-dynamism/dta/matching/cpsb`x' research/brookings-dynamism/dta/matching/cpsb`x'.raw
!chmod o-rwx research/brookings-dynamism/dta/matching/cpsb`x'.raw
infix double hrhhid 1-15 str hrsersuf 75-76 line 147-148 mis 63-64 age 122-123 race 139-140 sex 129-130 status 180-181 str dur 407-409 double fweight 613-622 double lweight 593-602 llind 69-70 educ 137-138 mar 125-126 str ind 856-859 str occu 860-863 state 91-92 using research/brookings-dynamism/dta/matching/cpsb`x'
generate z=real(hrsersuf)
replace z=0 if hrsersuf=="-1"
replace z=1 if hrsersuf=="A"
replace z=2 if hrsersuf=="B"
replace z=3 if hrsersuf=="C"
replace z=4 if hrsersuf=="D"
replace z=5 if hrsersuf=="E"
replace z=6 if hrsersuf=="F"
replace z=7 if hrsersuf=="G"
replace z=8 if hrsersuf=="H"
replace z=9 if hrsersuf=="I"
replace z=10 if hrsersuf=="J"
replace z=11 if hrsersuf=="K"
replace z=12 if hrsersuf=="L"
replace z=13 if hrsersuf=="M"
replace z=14 if hrsersuf=="N"
replace z=15 if hrsersuf=="O"
replace z=16 if hrsersuf=="P"
replace z=17 if hrsersuf=="Q"
replace z=18 if hrsersuf=="R"
replace z=19 if hrsersuf=="S"
replace z=20 if hrsersuf=="T"
replace z=21 if hrsersuf=="U"
replace z=22 if hrsersuf=="V"
replace z=23 if hrsersuf=="W"
replace z=24 if hrsersuf=="X"
replace z=26 if hrsersuf=="Y"
replace z=25 if hrsersuf=="Z"
generate double hh=hrhhid*100+z
replace dur="." if dur=="--"
replace ind="." if ind=="---"
replace occu="." if occu=="---"
drop hrhhid hrsersuf

compress
save mcr/scratch-m1cls01/data/cps/matching/cps`x'.dta, replace
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'.raw
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

while `x' <=201508 {
clear
!cp mcr/data_labor/cps/basic/raw/all/cpsb`x'.gz research/brookings-dynamism/dta/matching/cpsb`x'.gz
!gunzip research/brookings-dynamism/dta/matching/cpsb`x'.gz 
!mv research/brookings-dynamism/dta/matching/cpsb`x' research/brookings-dynamism/dta/matching/cpsb`x'.raw
!chmod o-rwx research/brookings-dynamism/dta/matching/cpsb`x'.raw
infix double hrhhid 1-15 str hrsersuf 75-76 line 147-148 mis 63-64 age 122-123 race 139-140 sex 129-130 status 180-181 str dur 407-409 double fweight 613-622 double lweight 593-602 llind 69-70 educ 137-138 mar 125-126 str ind 856-859 str occu 860-863 state 93-94 using research/brookings-dynamism/dta/matching/cpsb`x'
generate z=real(hrsersuf)
replace z=0 if hrsersuf=="-1"
replace z=1 if hrsersuf=="A"
replace z=2 if hrsersuf=="B"
replace z=3 if hrsersuf=="C"
replace z=4 if hrsersuf=="D"
replace z=5 if hrsersuf=="E"
replace z=6 if hrsersuf=="F"
replace z=7 if hrsersuf=="G"
replace z=8 if hrsersuf=="H"
replace z=9 if hrsersuf=="I"
replace z=10 if hrsersuf=="J"
replace z=11 if hrsersuf=="K"
replace z=12 if hrsersuf=="L"
replace z=13 if hrsersuf=="M"
replace z=14 if hrsersuf=="N"
replace z=15 if hrsersuf=="O"
replace z=16 if hrsersuf=="P"
replace z=17 if hrsersuf=="Q"
replace z=18 if hrsersuf=="R"
replace z=19 if hrsersuf=="S"
replace z=20 if hrsersuf=="T"
replace z=21 if hrsersuf=="U"
replace z=22 if hrsersuf=="V"
replace z=23 if hrsersuf=="W"
replace z=24 if hrsersuf=="X"
replace z=26 if hrsersuf=="Y"
replace z=25 if hrsersuf=="Z"
generate double hh=hrhhid*100+z
replace dur="." if dur=="--"
replace ind="." if ind=="---"
replace occu="." if occu=="---"
drop hrhhid hrsersuf

compress
save mcr/scratch-m1cls01/data/cps/matching/cps`x'.dta, replace
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'.raw
!rm -f research/brookings-dynamism/dta/matching/cpsb`x'

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}
