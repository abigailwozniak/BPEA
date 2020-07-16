* analysis of trends by state
set trace off
set more 1 
capture log close
clear
set linesize 250

log using j2jqwi.log, replace
* downloaded from http://lehd.ces.census.gov/data/j2j_beta.html
insheet using j2jqwi.csv, clear
drop if year==2014
collapse (mean) j2jsepr, by(year)
save j2jqwi, replace


quietly log close
