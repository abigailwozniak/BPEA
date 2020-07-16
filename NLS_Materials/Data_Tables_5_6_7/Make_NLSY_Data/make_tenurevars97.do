set more off

*** Create job, ind, occ, and location tenure variables for 1997 NLSY respondents. Use 3-digit 2002 Census ind/occ codes.
*** UPDATED from 2013 file of same name in Migration Decline project. REMOVED all use of geocoded data.

log using make_tenurevars97.log, replace

*use nlsy97_1997to2011.dta
use nlsy97_1997to2013.dta

summ indcen02* occcen02*

foreach x of numlist 1997/2011 2013 {
  replace indcen02_`x'=int(indcen02_`x' / 10) if indcen02_`x'>0
  replace occcen02_`x'=int(occcen02_`x' / 10) if occcen02_`x'>0
  }

summ indcen02* occcen02*

*** Some data checking


*** Use self reported tenure on main job, examine outliers on tenure and wages
*** Convert months of job tenure into years 
 
foreach x of numlist 1997/2011 2013 {
  qui gen trim_tenuremon1_`x' = tenuremon1_`x'
  qui egen temphi=pctile(tenuremon1_`x'), p(98.5)
  qui replace trim_tenuremon1_`x'=. if (tenuremon1_`x' > temphi)
  drop temphi
  qui gen tenureyr1_`x' = (tenuremon1_`x' / 12)
  qui gen trim_tenureyr1_`x' = (trim_tenuremon1_`x'/12)
  summ tenureyr1_`x' trim_tenureyr1_`x' if rhrp1_`x'~=.
}

summ tenuremon1* trim_tenuremon1* 
*bysort age1997: summ tenureyr1_* trim_tenureyr1_*

*** Wage outliers already trimmed in makedata_nlsy97 - but still have very high max tenure if condition on valid wages, in contrast to NLSY79
*** On the other hand, keeping tenure outliers adds 1-2 months to the mean months of tenure and also increases SD but maybe this is modest
*** Using trimmed wages and not trimming on tenure is same as in NBER paper

*** Examine main job wage by tenure

foreach x of numlist 1997/2011 2013 {
  qui gen validwage`x'=(rhrp1_`x'~=.)
  qui gen validten`x'=(tenuremon1_`x'~=.)
  summ age1997 rhrp1_`x' validwage`x' validten`x' if tenuremon1_`x' < 12
  summ age1997 rhrp1_`x' validwage`x' validten`x' if tenuremon1_`x' >= 12 & tenuremon1_`x'~=.
  summ age1997 rhrp1_`x' validwage`x' validten`x' if tenuremon1_`x'==.
}

drop validwage* validten*

*** Pattern is different from NLSY79 - here more likely to have valid wages if tenure < 12 mos than if >= 12 mos
*** Not sure why -- maybe dependent interviewing? Non-response? Rates are very close across two tenure groups, though.
*** As with NLSY79, small number of people have valid wages but no valid tenure

*** Harmonize jobid coding across years
summ job1id*
qui replace job1id1997=job1id1997 + 190000 if job1id1997 > 0
qui replace job1id1998=job1id1998 + 190000 if job1id1998 > 0
summ job1id* 

*** Dummy for non-interview

foreach x of numlist 1998/2011 2013 {
   gen insamp_`x'=1
   replace insamp_`x'=0 if region`x'==-5
   }
summ insamp*

*** BEGIN TENURE CALCULATIONS

*** Generate survey year zero values - using unadjusted wage and tenure data, merge in state change variables
*** Do tenure loop for one year interval years, then two year intervals

qui gen totmain=(tenureyr1_1997~=.)
qui gen dropout=0
qui gen jobten1997=.
qui gen indten1997=.
qui gen occten1997=.
qui gen ic1997=.
qui gen oc1997=.
qui gen jc1997=.
qui replace jobten1997=tenureyr1_1997 if totmain==1
qui replace indten1997=tenureyr1_1997 if totmain==1
qui replace occten1997=tenureyr1_1997 if totmain==1
qui replace jc1997=1 if tenureyr1_1997 < 1
qui replace jc1997=0 if tenureyr1_1997 >= 1 & tenureyr1_1997~=.

summ totmain
summ jobten1997 indten1997 occten1997 dropout if totmain==0
summ jobten1997 indten1997 occten1997 dropout if totmain==1
summ jobten1997 indten1997 occten1997 dropout if totmain > 1

*** Construct tenure variables for survey years 1 and beyond
*** totmain is number of times we have observed respondent with a main job in survey

*set trace on

foreach x of numlist 1998/2011 {

  local y = `x' - 1
  
  qui replace totmain=totmain + 1 if (tenureyr1_`x'~=.)
  qui replace dropout=1 if totmain > 1 & insamp_`x'==0
  
  capture drop mainisnew
  qui gen mainisnew=0
  qui replace mainisnew=1 if job1id`x'~=job1id`y' & job1id`x' > 0 
  qui replace mainisnew=1 if job1id`x'==-4
     
  qui gen jobten`x'=.
  qui gen indten`x'=.
  qui gen occten`x'=.
  qui gen ic`x'=.
  qui gen oc`x'=.
  qui gen jc`x'=.
  
  * if totmain==0... All ind,occ,job vars remain missing. Go to next loop iteration.
      
  * if totmain==1...
    qui replace jobten`x'=tenureyr1_`x' if totmain==1 
    qui replace indten`x'=tenureyr1_`x' if totmain==1 
    qui replace occten`x'=tenureyr1_`x' if totmain==1 
    qui replace jc`x'=1 if tenureyr1_`x' < 1 & totmain==1 
    qui replace jc`x'=0 if tenureyr1_`x' >= 1 & tenureyr1_`x'~=. & totmain==1   
  
  * if totmain > 1 and dropout==0 AND ...
    
    * S1... * S1... More than a year of tenure and main job was main job last year (not new) - ind, occ, job cannot change
    global conds1 totmain > 1 & dropout==0 & (tenureyr1_`x' >= 1 & tenureyr1_`x'~=.)
      qui replace jobten`x'=jobten`y' + 1 if $conds1 & mainisnew==0
      qui replace indten`x'=indten`y' + 1 if $conds1 & mainisnew==0
      qui replace occten`x'=occten`y' + 1 if $conds1 & mainisnew==0
      *qui replace indten`x'=jobten`x' if $conds1 & mainisnew==0
      *qui replace occten`x'=jobten`x' if $conds1 & mainisnew==0
      qui replace ic`x'=0 if $conds1 & mainisnew==0
      qui replace oc`x'=0 if $conds1 & mainisnew==0
      qui replace jc`x'=0 if $conds1 & mainisnew==0
      
    * S2... More than a year of tenure but main job is new to that position - allow for ind, occ and job change
    * Note that we may be recording the change a year late, if this year's main job was started last year but was not main    
      
      qui replace jobten`x'=tenureyr1_`x' if $conds1 & mainisnew==1

      qui replace indten`x'=indten`y' + 1 if (indcen02_`x'==indcen02_`y' & indcen02_`x'>0 & indcen02_`y'>0) & $conds1 & mainisnew==1
      qui replace ic`x'=0 if (indcen02_`x'==indcen02_`y' & indcen02_`x'>0 & indcen02_`y'>0) & $conds1 & mainisnew==1
      qui replace indten`x'=tenureyr1_`x' if (indcen02_`x'~=indcen02_`y' & indcen02_`x'>0 & indcen02_`y'>0) & $conds1 & mainisnew==1
      qui replace ic`x'=1 if (indcen02_`x'~=indcen02_`y' & indcen02_`x'>0 & indcen02_`y'>0) & $conds1 & mainisnew==1
      
      qui replace occten`x'=occten`y' + 1 if (occcen02_`x'==occcen02_`y' & occcen02_`x'>0 & occcen02_`y'>0) & $conds1 & mainisnew==1
      qui replace oc`x'=0 if (occcen02_`x'==occcen02_`y' & occcen02_`x'>0 & occcen02_`y'>0) & $conds1 & mainisnew==1
      qui replace occten`x'=tenureyr1_`x' if (occcen02_`x'~=occcen02_`y' & occcen02_`x'>0 & occcen02_`y'>0) & $conds1 & mainisnew==1
      qui replace oc`x'=1 if (occcen02_`x'~=occcen02_`y' & occcen02_`x'>0 & occcen02_`y'>0) & $conds1 & mainisnew==1

      qui replace jc`x'=1 if $conds1 & mainisnew==1
        
    
    * S3... Less than a year of tenure - same treatment if main job is new or not
    global conds2 totmain > 1 & dropout==0 & (0 <= tenureyr1_`x' & tenureyr1_`x' < 1)
    
      qui replace jobten`x'=tenureyr1_`x' if $conds2
      
      qui replace indten`x'=indten`y' + 1 if (indcen02_`x'==indcen02_`y' & indcen02_`x'>0 & indcen02_`y'>0) & $conds2
      qui replace ic`x'=0 if (indcen02_`x'==indcen02_`y' & indcen02_`x'>0 & indcen02_`y'>0) & $conds2
      qui replace indten`x'=tenureyr1_`x' if (indcen02_`x'~=indcen02_`y' & indcen02_`x'>0 & indcen02_`y'>0) & $conds2
      qui replace ic`x'=1 if (indcen02_`x'~=indcen02_`y' & indcen02_`x'>0 & indcen02_`y'>0) & $conds2
      
      qui replace occten`x'=occten`y' + 1 if (occcen02_`x'==occcen02_`y' & occcen02_`x'>0 & occcen02_`y'>0) & $conds2
      qui replace oc`x'=0 if (occcen02_`x'==occcen02_`y' & occcen02_`x'>0 & occcen02_`y'>0) & $conds2
      qui replace occten`x'=tenureyr1_`x' if (occcen02_`x'~=occcen02_`y' & occcen02_`x'>0 & occcen02_`y'>0) & $conds2
      qui replace oc`x'=1 if (occcen02_`x'~=occcen02_`y' & occcen02_`x'>0 & occcen02_`y'>0) & $conds2
    
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
   
   summ totmain dropout mainisnew tenureyr1_`x' jobten`x' indten`x' occten`x' if totmain==0
   summ totmain dropout mainisnew tenureyr1_`x' jobten`x' indten`x' occten`x' if totmain==1
   summ totmain dropout mainisnew tenureyr1_`x' jobten`x' indten`x' occten`x' if totmain > 1
   
}

foreach x of numlist 2013 {

  local y = `x' - 2
  
  qui replace totmain=totmain + 1 if (tenureyr1_`x'~=.)
  qui replace dropout=1 if totmain > 1 & insamp_`x'==0
  
  capture drop mainisnew
  qui gen mainisnew=0
  qui replace mainisnew=1 if job1id`x'~=job1id`y' & job1id`x' > 0 
  qui replace mainisnew=1 if job1id`x'==-4
     
  qui gen jobten`x'=.
  qui gen indten`x'=.
  qui gen occten`x'=.
  qui gen ic`x'=.
  qui gen oc`x'=.
  qui gen jc`x'=.
  
  * if totmain==0... All ind,occ,job vars remain missing. Go to next loop iteration.
      
  * if totmain==1...
    qui replace jobten`x'=tenureyr1_`x' if totmain==1 
    qui replace indten`x'=tenureyr1_`x' if totmain==1 
    qui replace occten`x'=tenureyr1_`x' if totmain==1 
    qui replace jc`x'=1 if tenureyr1_`x' < 2 & totmain==1 
    qui replace jc`x'=0 if tenureyr1_`x' >= 2 & tenureyr1_`x'~=. & totmain==1   
  
  * if totmain > 1 and dropout==0 AND ...
    
    * S1... * S1... More than 2 years of tenure and main job was main job last survey yr (not new) - ind, occ, job cannot change
    global conds1 totmain > 1 & dropout==0 & (tenureyr1_`x' >= 2 & tenureyr1_`x'~=.)
      qui replace jobten`x'=jobten`y' + 2 if $conds1 & mainisnew==0
      qui replace indten`x'=indten`y' + 2 if $conds1 & mainisnew==0
      qui replace occten`x'=occten`y' + 2 if $conds1 & mainisnew==0
      *qui replace indten`x'=jobten`x' if $conds1 & mainisnew==0
      *qui replace occten`x'=jobten`x' if $conds1 & mainisnew==0
      qui replace ic`x'=0 if $conds1 & mainisnew==0
      qui replace oc`x'=0 if $conds1 & mainisnew==0
      qui replace jc`x'=0 if $conds1 & mainisnew==0
      
    * S2... More than 2 years of tenure but main job is new to that position - allow for ind, occ and job change
    * Note that we may be recording the change a year late, if this year's main job was started last year but was not main    
      
      qui replace jobten`x'=tenureyr1_`x' if $conds1 & mainisnew==1

      qui replace indten`x'=indten`y' + 2 if (indcen02_`x'==indcen02_`y' & indcen02_`x'>0 & indcen02_`y'>0) & $conds1 & mainisnew==1
      qui replace ic`x'=0 if (indcen02_`x'==indcen02_`y' & indcen02_`x'>0 & indcen02_`y'>0) & $conds1 & mainisnew==1
      qui replace indten`x'=tenureyr1_`x' if (indcen02_`x'~=indcen02_`y' & indcen02_`x'>0 & indcen02_`y'>0) & $conds1 & mainisnew==1
      qui replace ic`x'=1 if (indcen02_`x'~=indcen02_`y' & indcen02_`x'>0 & indcen02_`y'>0) & $conds1 & mainisnew==1
      
      qui replace occten`x'=occten`y' + 2 if (occcen02_`x'==occcen02_`y' & occcen02_`x'>0 & occcen02_`y'>0) & $conds1 & mainisnew==1
      qui replace oc`x'=0 if (occcen02_`x'==occcen02_`y' & occcen02_`x'>0 & occcen02_`y'>0) & $conds1 & mainisnew==1
      qui replace occten`x'=tenureyr1_`x' if (occcen02_`x'~=occcen02_`y' & occcen02_`x'>0 & occcen02_`y'>0) & $conds1 & mainisnew==1
      qui replace oc`x'=1 if (occcen02_`x'~=occcen02_`y' & occcen02_`x'>0 & occcen02_`y'>0) & $conds1 & mainisnew==1

      qui replace jc`x'=1 if $conds1 & mainisnew==1
        
    
    * S3... Less than a year of tenure - same treatment if main job is new or not
    global conds2 totmain > 1 & dropout==0 & (0 <= tenureyr1_`x' & tenureyr1_`x' < 2)
    
      qui replace jobten`x'=tenureyr1_`x' if $conds2
      
      qui replace indten`x'=indten`y' + 2 if (indcen02_`x'==indcen02_`y' & indcen02_`x'>0 & indcen02_`y'>0) & $conds2
      qui replace ic`x'=0 if (indcen02_`x'==indcen02_`y' & indcen02_`x'>0 & indcen02_`y'>0) & $conds2
      qui replace indten`x'=tenureyr1_`x' if (indcen02_`x'~=indcen02_`y' & indcen02_`x'>0 & indcen02_`y'>0) & $conds2
      qui replace ic`x'=1 if (indcen02_`x'~=indcen02_`y' & indcen02_`x'>0 & indcen02_`y'>0) & $conds2
      
      qui replace occten`x'=occten`y' + 2 if (occcen02_`x'==occcen02_`y' & occcen02_`x'>0 & occcen02_`y'>0) & $conds2
      qui replace oc`x'=0 if (occcen02_`x'==occcen02_`y' & occcen02_`x'>0 & occcen02_`y'>0) & $conds2
      qui replace occten`x'=tenureyr1_`x' if (occcen02_`x'~=occcen02_`y' & occcen02_`x'>0 & occcen02_`y'>0) & $conds2
      qui replace oc`x'=1 if (occcen02_`x'~=occcen02_`y' & occcen02_`x'>0 & occcen02_`y'>0) & $conds2
    
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
   
   summ totmain dropout mainisnew tenureyr1_`x' jobten`x' indten`x' occten`x' if totmain==0
   summ totmain dropout mainisnew tenureyr1_`x' jobten`x' indten`x' occten`x' if totmain==1
   summ totmain dropout mainisnew tenureyr1_`x' jobten`x' indten`x' occten`x' if totmain > 1
   
}
summ totmain 
summ indten*
summ occten*
summ ic*
summ oc19* oc20*
summ jc*

* Summ ic and oc rates for our intended sample 

foreach x of numlist 1997/2011 2013 {
  qui gen testic`x'=ic`x' if age`x' >= 25 & age`x' <= 33 & wkswkann`x'>=26
  qui gen testoc`x'=oc`x' if age`x' >= 25 & age`x' <= 33  & wkswkann`x'>=26
}

summ testic*
summ testoc*

sort pubid
*save nlsy97tenure.dta, replace
save nlsy97tenure2013.dta, replace

log close
clear




