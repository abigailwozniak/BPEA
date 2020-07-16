log using table8.log ,replace

/***

Read in data from BLS special tabulations. Sharing data is allowed.

Note from BLS:

The enclosed spreadsheet contains the ratio of the 90th and 10th percentile total compensation estimates for private industry by Census division between March 1982 and March 2015. These estimates were constructed using the Employer Costs for Employee Compensation data, a product of the National Compensation Survey (NCS).  The NCS has recently transitioned from a locality based five sample rotation group design to a national based three sample rotation group design.  The change was necessitated as part of the enactment of the 2011 Federal Budget, where the Locality Pay Survey portion of the NCS was eliminated.  The classification of the nine census divisions have not changed but the sampling methodology and sample rotation has changed.  With the December 2015 estimates all private industry sample rotation groups are now part of the national sample design and a third of the sample will rotate each year, with the December reference period.  If you cite these data please indicate that they are unpublished estimates from the Bureau of Labor Statistics. 
 
For more information on the sample design changes please see the following resources: 
 
Handbook of methods: http://www.bls.gov/opub/hom/pdf/homch8.pdf
 
Evaluating Sample Design Issues in the National Compensation Survey: http://www.bls.gov/osmr/pdf/st100220.pdf
 
***/

import delimited using Input/90_10_percent_dissemination_csv.csv
summ
drop referencemonth

gen division=.
replace division=1 if censusdivision=="New England"
replace division=2 if censusdivision=="Middle Atlantic"
replace division=3 if censusdivision=="East North Central"
replace division=4 if censusdivision=="West North Central"
replace division=5 if censusdivision=="South Atlantic"
replace division=6 if censusdivision=="East South Central"
replace division=7 if censusdivision=="West South Central"
replace division=8 if censusdivision=="Mountain"
replace division=9 if censusdivision=="Pacific"

drop censusdivision

sort year division
save Output/div_90_10_compensationratio.dta, replace

gr twoway connect ratio year if division==8 || connect ratio year if division==9, saving(Output/ratio_west, replace)
gr twoway connect ratio year if division==1 || connect ratio year if division==2 || connect ratio year if division==3 || connect ratio year if division==4 || connect ratio year if division==5 || connect ratio year if division==6 || connect ratio year if division==7 || connect ratio year if division==8 || connect ratio year if division==9, saving(Output/ratio_all, replace)
gr twoway connect ratio year if division==1 || connect ratio year if division==2 || connect ratio year if division==3 || connect ratio year if division==4, saving(Output/ratio_ne_midwest, replace)

gen decade=.
replace decade=1 if year>=1982 & year <=1990
replace decade=2 if year>=2007 & year <=2015
drop if decade==.
collapse ratio, by(division decade)
reshape wide ratio, i(division) j(decade)
gen pc=(ratio2 - ratio1) / ratio1	
list

log close
clear

