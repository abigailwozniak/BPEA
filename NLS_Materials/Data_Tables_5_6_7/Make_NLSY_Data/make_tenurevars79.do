set more off

*** Create job, ind, occ, and location tenure variables for 1979 NLSY respondents over 1979 to 1994 period. Use 3-digit 1970 Census ind/occ codes.
*** UPDATED from 2013 file of same name in Migration Decline project. REMOVED all use of geocoded data.

log using make_tenurevars.log, replace

set mem 100m

use nlsy79_1979to1994.dta

sort caseid

* Unclassified occ code
forvalues x=79/94 {
  qui replace cpsocc70_`x'=-9 if cpsocc70_`x' >= 990 
}
*summ cpsocc70* cpsind70*


*** Some data checking on tenure measure

*** Use self reported tenure on main job, examine outliers on tenure
*** Convert months of job tenure into years 
 
foreach x of numlist 79/94 {
  qui gen trim_tenuremon1_`x' = tenuremon1_`x'
  qui egen temphi=pctile(tenuremon1_`x'), p(98.5)
  qui replace trim_tenuremon1_`x'=. if (tenuremon1_`x' > temphi)
  drop temphi
  qui gen tenureyr1_`x' = (tenuremon1_`x' / 12)
  qui gen trim_tenureyr1_`x' = (trim_tenuremon1_`x'/12)
}

summ tenuremon1* trim_tenuremon1* 
bysort age79: summ tenureyr1_* trim_tenureyr1_*

*** Wage outliers already trimmed in makedata_nlsy79 - trimming further on tenure does not seem that important, since tenure max looks similar in this sample whether trimmed or not
*** Using trimmed wages and not trimming on tenure is same as in NBER paper

*** Examine main job wage by tenure

foreach x of numlist 79/94 {
  qui gen validwage`x'=(rcpshrp`x'~=.)
  qui gen validten`x'=(tenuremon1_`x'~=.)
  summ age79 rcpshrp`x' validwage`x' validten`x' if tenuremon1_`x' < 12
  summ age79 rcpshrp`x' validwage`x' validten`x' if tenuremon1_`x' >= 12 & tenuremon1_`x'~=.
  summ age79 rcpshrp`x' validwage`x' validten`x' if tenuremon1_`x'==.
}

drop validwage* validten*

*** Small number of people have valid wages but no valid tenure

*** Dummy for non-interview

foreach x of numlist 80/94 {
   gen insamp_`x'=1
   replace insamp_`x'=0 if region`x'==-5
   }
summ insamp*


*** BEGIN TENURE CALCULATIONS

*** Generate survey year zero values 

qui gen totmain=(tenureyr1_79~=.)
qui gen dropout=0
qui gen jobten79=.
qui gen indten79=.
qui gen occten79=.
qui gen ic79=.
qui gen oc79=.
qui gen jc79=.
qui replace jobten79=tenureyr1_79 if totmain==1
qui replace indten79=tenureyr1_79 if totmain==1
qui replace occten79=tenureyr1_79 if totmain==1
qui replace jc79=1 if tenureyr1_79 < 1
qui replace jc79=0 if tenureyr1_79 >= 1 & tenureyr1_79~=.

qui gen job1iscps94=1

summ totmain
summ tenureyr1_79 jobten79 indten79 occten79 dropout if totmain==0
summ tenureyr1_79 jobten79 indten79 occten79 dropout if totmain==1
summ tenureyr1_79 jobten79 indten79 occten79 dropout if totmain > 1


/*** CONSTRUCTING TENURE VARIABLES ***/

*** Construct tenure variables for survey years 1 and beyond
*** totmain is number of times we have observed respondent with a main job in survey

*** do not code tenure anymore (drop obs) AFTER an indiv is not surveyed at some point after reporting at least one main job 
*** that is, cannot leave and return to sample after reporting a main job -- this way we know that missing tenureyr1 is due to UE

*** Main changes from NBER analysis 1) Cannot use changing states as regulator of ind, occ change and 2) code R as dropout if CPS/main job is not job 1
*** For 1980 to 1994, code anyone as dropout if job1 is not cps - because occ, ind variables are for CPS job

foreach x of numlist 80/94 {
  local y = `x' - 1
  
  qui replace totmain=totmain + 1 if (tenureyr1_`x'~=.)
  qui replace dropout=1 if (totmain >= 1 & insamp_`x'==0) | job1iscps`x'==0

  capture drop mainiscps mainisnew
  * CHANGE from NBER analysis - fixed default coding of mainiscps=1 if missing job1iscps
  qui gen mainiscps=.
  qui replace mainiscps=1 if job1iscps`x'==1
  qui replace mainiscps=0 if mainiscps==.
  * dummy for job being new to the main job position
  qui gen mainisnew=0
  qui replace mainisnew=1 if emp1previd`x' > 1 | emp1previd`x'==-4
    
  qui gen jobten`x'=.
  qui gen indten`x'=.
  qui gen occten`x'=.
  qui gen ic`x'=.
  qui gen oc`x'=.
  qui gen jc`x'=.
  
  * if totmain==0... All ind,occ,job vars remain missing. Go to next loop iteration.
  
  * if totmain==1...
    qui replace jobten`x'=tenureyr1_`x' if totmain==1 & dropout==0
    qui replace indten`x'=tenureyr1_`x' if totmain==1 & dropout==0
    qui replace occten`x'=tenureyr1_`x' if totmain==1 & dropout==0
    qui replace jc`x'=1 if tenureyr1_`x' < 1 & totmain==1 & dropout==0 
    qui replace jc`x'=0 if tenureyr1_`x' >= 1 & tenureyr1_`x'~=. & totmain==1 & dropout==0
  
  
  * if totmain > 1 and dropout==0 AND ...
    
    * S1... More than a year of tenure and main job was main job last year (not new) - ind, occ, job cannot change
    global conds1 totmain > 1 & dropout==0 & (tenureyr1_`x' >= 1 & tenureyr1_`x'~=.)
      
      qui replace jobten`x'=jobten`y' + 1 if $conds1 & mainisnew==0
      *qui replace indten`x'=jobten`x' if $conds1 & mainisnew==0
      *qui replace occten`x'=jobten`x' if $conds1 & mainisnew==0
      qui replace indten`x'=indten`y' + 1 if $conds1 & mainisnew==0
      qui replace occten`x'=occten`y' + 1 if $conds1 & mainisnew==0
      qui replace ic`x'=0 if $conds1 & mainisnew==0
      qui replace oc`x'=0 if $conds1 & mainisnew==0
      qui replace jc`x'=0 if $conds1 & mainisnew==0
      
    * S2... More than a year of tenure but main job is new to that position - allow for ind, occ and job change
    * Note that we may be recording the change a year late, if this year's main job was started last year but was not main
      
      qui replace jobten`x'=tenureyr1_`x' if $conds1 & mainisnew==1
      
      qui replace indten`x'=indten`y' + 1 if (cpsind70_`x'==cpsind70_`y' & cpsind70_`x'>0 & cpsind70_`y'>0) & $conds1 & mainisnew==1
      qui replace ic`x'=0 if (cpsind70_`x'==cpsind70_`y' & cpsind70_`x'>0 & cpsind70_`y'>0) & $conds1 & mainisnew==1
      qui replace indten`x'=tenureyr1_`x' if (cpsind70_`x'~=cpsind70_`y' & cpsind70_`x'>0 & cpsind70_`y'>0) & $conds1 & mainisnew==1
      qui replace ic`x'=1 if (cpsind70_`x'~=cpsind70_`y' & cpsind70_`x'>0 & cpsind70_`y'>0) & $conds1 & mainisnew==1
      
      qui replace occten`x'=occten`y' + 1 if (cpsocc70_`x'==cpsocc70_`y' & cpsocc70_`x'>0 & cpsocc70_`y'>0) & $conds1 & mainisnew==1
      qui replace oc`x'=0 if (cpsocc70_`x'==cpsocc70_`y' & cpsocc70_`x'>0 & cpsocc70_`y'>0) & $conds1 & mainisnew==1
      qui replace occten`x'=tenureyr1_`x' if (cpsocc70_`x'~=cpsocc70_`y' & cpsocc70_`x'>0 & cpsocc70_`y'>0) & $conds1 & mainisnew==1
      qui replace oc`x'=1 if (cpsocc70_`x'~=cpsocc70_`y' & cpsocc70_`x'>0 & cpsocc70_`y'>0) & $conds1 & mainisnew==1
    
      qui replace jc`x'=1 if $conds1 & mainisnew==1
       
    * S3... Less than a year of tenure - same treatment if main job is new or not
    global conds2 totmain > 1 & dropout==0 & (0 <= tenureyr1_`x' & tenureyr1_`x' < 1)
    
      qui replace jobten`x'=tenureyr1_`x' if $conds2
      
      qui replace indten`x'=indten`y' + 1 if (cpsind70_`x'==cpsind70_`y' & cpsind70_`x'>0 & cpsind70_`y'>0) & $conds2
      qui replace ic`x'=0 if (cpsind70_`x'==cpsind70_`y' & cpsind70_`x'>0 & cpsind70_`y'>0) & $conds2
      qui replace indten`x'=tenureyr1_`x' if (cpsind70_`x'~=cpsind70_`y' & cpsind70_`x'>0 & cpsind70_`y'>0) & $conds2
      qui replace ic`x'=1 if (cpsind70_`x'~=cpsind70_`y' & cpsind70_`x'>0 & cpsind70_`y'>0) & $conds2
      
      qui replace occten`x'=occten`y' + 1 if (cpsocc70_`x'==cpsocc70_`y' & cpsocc70_`x'>0 & cpsocc70_`y'>0) & $conds2
      qui replace oc`x'=0 if (cpsocc70_`x'==cpsocc70_`y' & cpsocc70_`x'>0 & cpsocc70_`y'>0) & $conds2
      qui replace occten`x'=tenureyr1_`x' if (cpsocc70_`x'~=cpsocc70_`y' & cpsocc70_`x'>0 & cpsocc70_`y'>0) & $conds2
      qui replace oc`x'=1 if (cpsocc70_`x'~=cpsocc70_`y' & cpsocc70_`x'>0 & cpsocc70_`y'>0) & $conds2
    
      qui replace jc`x'=1 if $conds2

    * No S4 anymore...
    
    * S5... Missing tenure, but in survey and had main job previously -- assume these may be OLF so no job tenure but holding ind, occ tenure constant at prior level
    global conds5 totmain > 1 & dropout==0 & tenureyr1_`x'==.
    
      qui replace jobten`x'=. if $conds5
      qui replace indten`x'=indten`y' if $conds5
      qui replace occten`x'=occten`y' if $conds5
      qui replace ic`x'=0 if $conds5
      qui replace oc`x'=0 if $conds5
      qui replace jc`x'=0 if $conds5
    
   summ totmain dropout mainiscps mainisnew tenureyr1_`x' jobten`x' indten`x' occten`x' if totmain==0
   summ totmain dropout mainiscps mainisnew tenureyr1_`x' jobten`x' indten`x' occten`x' if totmain==1
   summ totmain dropout mainiscps mainisnew tenureyr1_`x' jobten`x' indten`x' occten`x' if totmain > 1
   
}

summ totmain 
summ indten*
summ occten*
summ ic*
summ oc7* oc8* oc9*
summ jc*

* Summ ic and oc rates for our intended sample -- these look more realistic

foreach x of numlist 79/94 {
  qui gen testic`x'=ic`x' if (age79 + (`x' - 79)) >= 25 & (age79 + (`x' - 79)) <= 30 & wkswk_pcy`x'>=26
  qui gen testoc`x'=oc`x' if (age79 + (`x' - 79)) >= 25 & (age79 + (`x' - 79)) <= 30 & wkswk_pcy`x'>=26
}

summ testic*
summ testoc*

sort caseid
save nlsy79tenure.dta, replace

log close
clear




