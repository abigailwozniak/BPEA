set more off

*** Create job, ind, occ, and location tenure variables for NLS-YM respondents. Use 3-digit ind/occ codes provided by NLS.
*** Gets reasonably close but not exact match to stats in Table 5 of NBER paper. This is a from scratch reconstruction, so not surprising that it's a little bit off.

log using make_tenurevarsYM.log, replace

use nlsym_all.dta
sort caseid

* Unclassified occ code
foreach x of numlist 66/71 73 75 76 78 80 81 {
  qui replace occ`x'=-9 if occ`x' >= 995 
  qui replace ind`x'=-9 if ind`x' >= 999 
}
*summ occ* 

* Dummy for in sample - code people as not in sample if interview year not equal to survey year in 66/71 81 (this line is new from NBER)

foreach x of numlist 66/71 73 75 76 78 80 81 {
   gen insamp_`x'=1
   replace insamp_`x'=0 if region`x'< 0
   }
foreach x of numlist 66/71 81 {
   replace insamp_`x'=0 if intyear`x'~=`x'
   }
summ insamp*

*** Create job tenure - First create jobten for each year, using forced incrementing where applicable

summ yearstart* monthstart*

foreach x of numlist 66 {
*foreach x of numlist 70 {
*foreach x of numlist 73 {
   gen jobten`x'= [(`x' - yearstart`x')*12 + (intmonth`x' - monthstart`x')] / 12
   replace jobten`x'=. if yearstart`x'<0 | monthstart`x'<0 | intmonth`x'<0 | insamp_`x'==0
   replace jobten`x'=. if yearstart`x' > `x' | (yearstart`x'==`x' & intmonth`x' < monthstart`x')
}

* Note empr = 0 is self-employed, exlude them from tenure calculations

*set trace on
foreach x of numlist 67/71 73 75 76 78 80 81 {
*foreach x of numlist 71 73 75 76 78 80 81 {
*foreach x of numlist 75 76 78 80 81 {

  if `x'==73 | `x'==75 | `x'==78 | `x'==80 {
  local y = `x' - 2
  local d = 2
  }
  else {
  local y = `x' - 1
  local d = 1
  }

  qui gen jobten`x'=.
  qui gen mainisnew=0
  *summ jobten`x' mainisnew
  qui replace mainisnew=1 if empr`x'~=empr`y' & empr`x'>0 & empr`y'>0
  qui replace mainisnew=1 if empr`x'>0 & empr`y'<0
  *summ jobten`x' mainisnew
  
* Main job is new
   global new1 mainisnew==1 | (mainisnew==0 & jobten`y'==.)
   replace jobten`x'= [(`x' - yearstart`x')*12 + (intmonth`x' - monthstart`x')] / 12 if $new1
   replace jobten`x'=. if (yearstart`x'<0 | monthstart`x'<0 | intmonth`x'<0 | insamp_`x'==0)  & $new1
   replace jobten`x'=. if ((yearstart`x' > `x') | (yearstart`x'==`x' & intmonth`x' < monthstart`x'))  & $new1

* Main job is not new - should address fact that job start dates only asked of job changers in 68, 69
   replace jobten`x'=jobten`y' + `d' if empr`x'==empr`y' & empr`x'>0 & empr`y'>0
  
   summ jobten`x' mainisnew
   drop mainisnew
}
*set trace off

* A few obs have job start dates in the future - set those to missing tenure in loop above
*summ jobten* flag*
*summ jobten* trimten*
summ jobten* empr*
*tab1 empr66 empr67 empr68 yearstart66 yearstart67 yearstart68 monthstart66 monthstart67 monthstart68 intmonth66 intmonth67 intmonth68

* In general, 67, 68, 69 seem to possibly be different than other job tenure responses, but can't figure out why in documentation
* 70, 71 seems to have start year of job truncated at 1967, but mean start year (including -4's) looks similar from 1970 on, before that jumps around a lot


*** BEGIN TENURE CALCULATIONS - this calculates ind and occ tenure, and ic, oc, jc variables

*** Generate survey year zero values 

qui gen totmain=(jobten66~=.)
qui gen dropout=0
qui gen indten66=.
qui gen occten66=.
qui gen ic66=.
qui gen oc66=.
qui gen jc66=.
qui replace indten66=jobten66 if totmain==1
qui replace occten66=jobten66 if totmain==1
qui replace jc66=1 if jobten66 < 1
qui replace jc66=0 if jobten66 >= 1 & jobten66~=.

summ totmain
summ rpce_hrp66 jobten66 indten66 occten66 ic66 oc66 jc66 dropout if totmain==0
summ rpce_hrp66 jobten66 indten66 occten66 ic66 oc66 jc66 dropout if totmain==1
summ rpce_hrp66 jobten66 indten66 occten66 ic66 oc66 jc66 dropout if totmain > 1

/*** CONSTRUCTING TENURE VARIABLES ***/

*set trace on

foreach x of numlist 67/71 73 75 76 78 80 81 {
*foreach x of numlist 75 76 78 80 81 {

  if `x'==73 | `x'==75 | `x'==78 | `x'==80 {
  local y = `x' - 2
  local d = 2
  }
  else {
  local y = `x' - 1
  local d = 1
  }
  
  qui replace totmain=totmain + 1 if (jobten`x'~=.)
  qui replace dropout=1 if (totmain >= 1 & insamp_`x'==0) 
  
  capture drop mainisnew
* dummy for being new to the main/cps job position
  qui gen mainisnew=0
  qui replace mainisnew=1 if empr`x'~=empr`y' & empr`x'>=0 & empr`y'>=0
  qui replace mainisnew=1 if empr`x'>=0 & empr`y'<0
  
  qui gen indten`x'=.
  qui gen occten`x'=.
  qui gen ic`x'=.
  qui gen oc`x'=.
  qui gen jc`x'=.
  
  * if totmain==0... All ind,occ,job vars remain missing. Go to next loop iteration.
  
  * if totmain==1...
    qui replace indten`x'=jobten`x' if totmain==1 & dropout==0
    qui replace occten`x'=jobten`x' if totmain==1 & dropout==0
    qui replace jc`x'=1 if jobten`x' < `d' & jobten`x'~=. & totmain==1 & dropout==0 
    qui replace jc`x'=0 if jobten`x' >= `d' & jobten`x'~=. & totmain==1 & dropout==0

  * if totmain > 1 and dropout==0 AND ...
    
    * S1... More than a time unit of tenure and main job was main job last year (not new) - ind, occ, job cannot change
    global conds1 totmain > 1 & dropout==0 & (jobten`x' >= `d' & jobten`x'~=.)
      
      *qui replace jobten`x'=jobten`y' + `d' if $conds1 & mainisnew==0
      *qui replace indten`x'=jobten`x' if $conds1 & mainisnew==0   
      *qui replace occten`x'=jobten`x' if $conds1 & mainisnew==0   
      qui replace indten`x'=indten`y' + `d' if $conds1 & mainisnew==0   
      qui replace occten`x'=occten`y' + `d' if $conds1 & mainisnew==0   
      qui replace ic`x'=0 if $conds1 & mainisnew==0
      qui replace oc`x'=0 if $conds1 & mainisnew==0
      qui replace jc`x'=0 if $conds1 & mainisnew==0
      
    * S2... More than a time unit of tenure but main job is new to that position - allow for ind, occ and job change
    * Note that we may be recording the change a year late, if this year's main job was started last year but was not main
      
      qui replace indten`x'=indten`y' + `d' if (ind`x'==ind`y' & ind`x'>0 & ind`y'>0) & $conds1 & mainisnew==1
      qui replace ic`x'=0 if (ind`x'==ind`y' & ind`x'>0 & ind`y'>0) & $conds1 & mainisnew==1
      qui replace indten`x'=jobten`x' if (ind`x'~=ind`y' & ind`x'>0 & ind`y'>0) & $conds1 & mainisnew==1
      qui replace ic`x'=1 if (ind`x'~=ind`y' & ind`x'>0 & ind`y'>0) & $conds1 & mainisnew==1
      
      qui replace occten`x'=occten`y' + `d' if (occ`x'==occ`y' & occ`x'>0 & occ`y'>0) & $conds1 & mainisnew==1
      qui replace oc`x'=0 if (occ`x'==occ`y' & occ`x'>0 & occ`y'>0) & $conds1 & mainisnew==1
      qui replace occten`x'=jobten`x' if (occ`x'~=occ`y' & occ`x'>0 & occ`y'>0) & $conds1 & mainisnew==1
      qui replace oc`x'=1 if (occ`x'~=occ`y' & occ`x'>0 & occ`y'>0) & $conds1 & mainisnew==1
    
      qui replace jc`x'=1 if $conds1 & mainisnew==1
       
    * S3... Less than a time unit of tenure - same treatment if main job is new or not
    global conds2 totmain > 1 & dropout==0 & (0 <= jobten`x' & jobten`x' < `d')
    
      qui replace indten`x'=indten`y' + `d' if (ind`x'==ind`y' & ind`x'>0 & ind`y'>0) & $conds2
      qui replace ic`x'=0 if (ind`x'==ind`y' & ind`x'>0 & ind`y'>0) & $conds2
      qui replace indten`x'=jobten`x' if (ind`x'~=ind`y' & ind`x'>0 & ind`y'>0) & $conds2
      qui replace ic`x'=1 if (ind`x'~=ind`y' & ind`x'>0 & ind`y'>0) & $conds2
      
      qui replace occten`x'=occten`y' + `d' if (occ`x'==occ`y' & occ`x'>0 & occ`y'>0) & $conds2
      qui replace oc`x'=0 if (occ`x'==occ`y' & occ`x'>0 & occ`y'>0) & $conds2
      qui replace occten`x'=jobten`x' if (occ`x'~=occ`y' & occ`x'>0 & occ`y'>0) & $conds2
      qui replace oc`x'=1 if (occ`x'~=occ`y' & occ`x'>0 & occ`y'>0) & $conds2
    
      qui replace jc`x'=1 if $conds2

    * No S4 anymore...
    
    * S5... Missing tenure, but in survey and had main job previously -- assume these may be OLF so no job tenure but holding ind, occ tenure constant at prior level
    global conds5 totmain > 1 & dropout==0 & jobten`x'==.
    
      qui replace indten`x'=indten`y' if $conds5
      qui replace occten`x'=occten`y' if $conds5
      qui replace ic`x'=0 if $conds5
      qui replace oc`x'=0 if $conds5
      qui replace jc`x'=0 if $conds5
       
   summ totmain dropout rpce_hrp`x' jobten`x' indten`x' occten`x' jc`x' ic`x' oc`x' if totmain==0
   summ totmain dropout rpce_hrp`x' jobten`x' indten`x' occten`x' jc`x' ic`x' oc`x' if totmain==1
   summ totmain dropout rpce_hrp`x' jobten`x' indten`x' occten`x' jc`x' ic`x' oc`x' if totmain > 1
      
}

summ totmain 
summ indten*
summ occten*
summ ic*
summ oc7* oc8*
summ jc*

* Summ ic and oc rates for our intended sample -- these look more realistic

foreach x of numlist 73 75 76 78 80 81  { 
qui gen testic`x'=ic`x' if age`x' >=22 & age`x' <= 33 & wkswk_pcy`x'>=26 
qui gen testoc`x'=oc`x' if age`x' >=22 & age`x' <= 33 & wkswk_pcy`x'>=26 
}

summ testic*
summ testoc*

sort caseid
save nlsym_tenure.dta, replace

log close
clear

