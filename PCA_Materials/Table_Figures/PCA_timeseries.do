
	*** Code to replicate the time series analysis 
	*** of "Understanding Declining Fluidity in the U.S. Labor Market"
	*** by R. Molloy, C. Smith, R. Trezzi, and A. Wozniak
	
	clear all
	set more off
	capture log close
    log using PCA_timeseries.log, replace
	
	*** CHANGE THIS DIRECTORY

	**********************************
	***
	*** QUARTERLY SERIES
	***
	**********************************	
	
	clear
	*use quarterly_series.dta	
	use Input/quarterly_series.dta	
	
	/*
	quietly: tsbiweight_cea eu_cea_long = eu, window(90)
	quietly: tsbiweight_cea ue_cea_long = ue, window(90) 
	quietly: tsbiweight_cea en_cea_long = en, window(90) 
	quietly: tsbiweight_cea ne_cea_long = ne, window(90)
	*/
	
	**** PCA 
		
	* Table 3 of the paper (column 1)	
	pca eu_cea_long ue_cea_long en_cea_long ne_cea_long
	predict f1
	rename f1 f1_pcasecond_cea_long
	
	* Table A5 of the paper (column 1)
	pca en_q2 ne_q2 eu_q2 ue_q2
	
	* Table A4 of the paper (column 1)	
	pca en_trend_cf1 ne_trend_cf1 eu_trend_cf1 ue_trend_cf1
		
	collapse (mean) f1_pcasecond_cea_long, by(year)
	
	rename f1_pcasecond_cea_long q_f1_pcasecond_cea_long
	
	*save first_components_quarterly.dta, replace
	save Output/first_components_quarterly.dta, replace
	
	********************************************************
	***
	*** FIGURE 1 of the paper
	***
	********************************************************
	

	clear
	
	set more off
	*use quarterly_series.dta
	use Input/quarterly_series.dta
	
	graph set window fontface       "Times New Roman"
	graph set window fontfacesans   "Times New Roman"
	graph set window fontfaceserif  "Times New Roman"
	graph set window fontfacemono   "Times New Roman"
	graph set window fontfacesymbol "Times New Roman"	

	** EU
	
	label var eu_cea_long  "Biweight"
	
	twoway (line eu_cea_long time_chart, lwidth(medthick) lpattern(dash) lcolor(blue) legend(off) xtitle("") ytitle("") title("EU", size(medlarge) color(black)) legend(off) ///
		    plotregion(color(white)) plotregion(ilcolor(white)) graphregion(color(white)) bgcolor(white)) ///
		   (line eu time_chart, lwidth(medthick) lcolor(blue))
	
	graph save   Output/Figures_GPH/Figure_1/Figure1_EU.gph, replace	
	graph export Output/Figures_PDF/Figure_1/Figure1_EU.pdf, replace	
	   	
	** UE
	
	label var ue_cea_long  "Biweight"
	
	twoway (line ue_cea_long time_chart, lwidth(medthick) lpattern(dash) lcolor(red) legend(off) xtitle("") ytitle("") title("UE", size(medlarge) color(black)) legend(off) ///
		    plotregion(color(white)) plotregion(ilcolor(white)) graphregion(color(white)) bgcolor(white)) ///
	       (line ue time_chart, lwidth(medthick) lcolor(red))


	graph save   Output/Figures_GPH/Figure_1/Figure1_UE.gph, replace	
	graph export Output/Figures_PDF/Figure_1/Figure1_UE.pdf, replace	
	   	
	** EN
	
	label var en_cea_long  "Biweight"
	
	twoway (line en_cea_long time_chart, lwidth(medthick) lpattern(dash) lcolor(gold) legend(off) xtitle("") ytitle("") title("EN", size(medlarge) color(black)) legend(off) ///
		    plotregion(color(white)) plotregion(ilcolor(white)) graphregion(color(white)) bgcolor(white)) ///
		   (line en time_chart, lwidth(medthick) lcolor(gold))

	graph save   Output/Figures_GPH/Figure_1/Figure1_EN.gph, replace	
	graph export Output/Figures_PDF/Figure_1/Figure1_EN.pdf, replace		
	
	** NE
	
	label var ne_cea_long  "Biweight"
	
	twoway (line ne_cea_long time_chart, lwidth(medthick) lpattern(dash) lcolor(green) legend(off) xtitle("") ytitle("") title("NE", size(medlarge) color(black)) legend(off) ///
		    plotregion(color(white)) plotregion(ilcolor(white)) graphregion(color(white)) bgcolor(white)) ///
		   (line ne time_chart, lwidth(medthick) lcolor(green))
		   
	graph save   Output/Figures_GPH/Figure_1/Figure1_NE.gph, replace	
	graph export Output/Figures_PDF/Figure_1/Figure1_NE.pdf, replace	
	
	**********************************
	***
	*** ANNUAL SERIES
	***
	**********************************	
	
	clear
	set more off
	
	*use annual_series.dta
	use Input/annual_series.dta
	
	/*
	*CF trend
	quietly: tsfilter cf eu_cf = eu,  trend(eu_trend_cf)  minperiod(2) maxperiod(30)	
	quietly: tsfilter cf ue_cf = ue,  trend(ue_trend_cf)  minperiod(2) maxperiod(30)	
	quietly: tsfilter cf en_cf = en,  trend(en_trend_cf)  minperiod(2) maxperiod(30)
	quietly: tsfilter cf ne_cf = ne,  trend(ne_trend_cf)  minperiod(2) maxperiod(30)
	quietly: tsfilter cf empchangeipums_cf = empchangeipums,  trend(empchangeipums_trend_cf)  minperiod(2) maxperiod(30)
	quietly: tsfilter cf smigirs_cf = smigirs,  trend(smigirs_trend_cf)  minperiod(2) maxperiod(30)
	quietly: tsfilter cf jdr_cf = jdr,  trend(jdr_trend_cf)  minperiod(2) maxperiod(30)
	quietly: tsfilter cf jcr_cf = jcr,  trend(jcr_trend_cf)  minperiod(2) maxperiod(30)
		
	*Biweight filter
	quietly:  tsbiweight_cea eu_cea = eu, window(30)
	replace eu_cea = . if eu == .	
	quietly:  tsbiweight_cea ue_cea = ue, window(30)
	replace ue_cea = . if ue == .
	quietly:  tsbiweight_cea en_cea = en, window(30)
	replace en_cea = . if en == .
	quietly:  tsbiweight_cea ne_cea = ne, window(30)
	replace ne_cea = . if ne == .
	quietly:  tsbiweight_cea empchangeipums_cea = empchangeipums, window(30)
	replace empchangeipums_cea = . if empchangeipums == .
	quietly:  tsbiweight_cea smigirs_cea = smigirs, window(30)
	replace smigirs_cea = . if smigirs == .
	quietly:  tsbiweight_cea jdr_cea = jdr, window(30)
	replace jdr_cea = . if jdr == .
	quietly:  tsbiweight_cea jcr_cea = jcr, window(30)
	replace jcr_cea = . if jcr == .	*/
	
	*** Tables
	
	* Table 1 of the paper
	sum eu_cea ue_cea en_cea ne_cea empchangeipums_cea smigirs_cea jdr_cea jcr_cea if year >=1975

	* Table 2 of the paper	
	pwcorr eu_cea ue_cea en_cea ne_cea empchangeipums_cea smigirs_cea jdr_cea jcr_cea, sig
	
	* Table A2 of the paper
	pwcorr eu_trend_cf ue_trend_cf en_trend_cf ne_trend_cf empchangeipums_trend_cf smigirs_trend_cf jdr_trend_cf jcr_trend_cf, sig

	* Table A3 of the paper	
	pwcorr eu_a_q2 ue_a_q2 en_a_q2 ne_a_q2 empchangeipums_a_q2 smigirs_a_q2 jdr_a_q2 jcr_a_q2, sig
	

	*** Principal Component Analysis		
	
	** PCA on TRENDS 5 variables	
	** Table 3 column2
	pca eu_cea ue_cea en_cea ne_cea empchangeipums_cea 
	predict f1
	rename f1 f1_pcasecond_6var
	
	** PCA on TRENDS 8 variables
	** Table 3 column3	
	pca eu_cea ue_cea en_cea ne_cea empchangeipums_cea smigirs_cea jdr_cea jcr_cea
	predict f1
	rename f1 f1_pcasecond_8var

	** PCA on CF TRENDS 5 variables
	** Table A4 column 2
	pca eu_trend_cf ue_trend_cf en_trend_cf ne_trend_cf empchangeipums_trend_cf  
	
	** PCA on CF TRENDS 8 variables
	** Table A4 column 3
	pca eu_trend_cf ue_trend_cf en_trend_cf ne_trend_cf empchangeipums_trend_cf smigirs_trend_cf jdr_trend_cf jcr_trend_cf
	predict f1
	rename f1 f1_cf_pcasecond_8var

	** PCA on Cosine TRENDS 5 variables
	** Table A5 column 2	
	pca eu_a_q2 ue_a_q2 en_a_q2 ne_a_q2 empchangeipums_a_q2 
	
	** PCA on Cosine TRENDS 8 variables
	** Table A5 column 3	
	pca eu_a_q2 ue_a_q2 en_a_q2 ne_a_q2 empchangeipums_a_q2 smigirs_a_q2 jdr_a_q2 jcr_a_q2
	predict f1
	rename f1 f1_cos_pcasecond_8var
	
	rename f1_pcasecond_6var          a_f1_pcasecond_6var
	rename f1_pcasecond_8var          a_f1_pcasecond_8var
	rename f1_cf_pcasecond_8var       a_f1_cf_pcasecond_8var
	rename f1_cos_pcasecond_8var      a_f1_cos_pcasecond_8var
	
	*save first_components_annual_transitory.dta, replace 	
	save Output/first_components_annual_transitory.dta, replace 	
	
	keep year a_f1_pcasecond_6var a_f1_pcasecond_8var a_f1_cf_pcasecond_8var a_f1_cos_pcasecond_8var
	*save first_components_annual.dta, replace 
	save Output/first_components_annual.dta, replace 
		
	*************************
	***
	*** Figure 2 of the paper
	***
	*************************
	
	clear
	
	set more off
	use Input/annual_series.dta
	
	graph set window fontface       "Times New Roman"
	graph set window fontfacesans   "Times New Roman"
	graph set window fontfaceserif  "Times New Roman"
	graph set window fontfacemono   "Times New Roman"
	graph set window fontfacesymbol "Times New Roman"	

	*JtJ
	
	twoway (line empchangeipums_cea year if year>=1975, lwidth(medthick) lcolor(black) lpattern(dash) plotregion(color(white)) ///
			plotregion(ilcolor(white)) graphregion(color(white)) bgcolor(white) legend(off) xtitle("") ytitle("") title("Job to job transition", size(medlarge) color(black))) ///
		   (line empchangeipums year if year>=1975, lwidth(medthick) lcolor(black))	
			
	graph save   Output/Figures_GPH/Figure_2/Figure2_JtJ.gph, replace	
	graph export Output/Figures_PDF/Figure_2/Figure2_JtJ.pdf, replace	

	*IM
	twoway (line smigirs_cea year if year>=1975, lwidth(medthick) lcolor(orange) lpattern(dash) plotregion(color(white)) ///
			plotregion(ilcolor(white)) graphregion(color(white)) bgcolor(white) legend(off) xtitle("") ytitle("") title("Interstate migration", size(medlarge) color(black))) ///
		   (line smigirs year if year>=1975, lwidth(medthick) lcolor(orange))	
			
	graph save   Output/Figures_GPH/Figure_2/Figure2_IM.gph, replace	
	graph export Output/Figures_PDF/Figure_2/Figure2_IM.pdf, replace	

	*JDR
	twoway (line jdr_cea year if year>=1975, lwidth(medthick) lcolor(ltblue) lpattern(dash) plotregion(color(white)) ///
			plotregion(ilcolor(white)) graphregion(color(white)) bgcolor(white) legend(off) xtitle("") ytitle("") title("Job destruction rate", size(medlarge) color(black))) ///
		   (line jdr year if year>=1975, lwidth(medthick) lcolor(ltblue))	

	graph save   Output/Figures_GPH/Figure_2/Figure2_JDR.gph, replace	
	graph export Output/Figures_PDF/Figure_2/Figure2_JDR.pdf, replace	
	
	*JCR
	twoway (line jcr_cea year if year>=1975, lwidth(medthick) lcolor(lavender) lpattern(dash) plotregion(color(white)) ///
			plotregion(ilcolor(white)) graphregion(color(white)) bgcolor(white) legend(off) xtitle("") ytitle("") title("Job creation rate", size(medlarge) color(black))) ///
		   (line jcr year if year>=1975, lwidth(medthick) lcolor(lavender))	

	graph save   Output/Figures_GPH/Figure_2/Figure2_JCR.gph, replace	
	graph export Output/Figures_PDF/Figure_2/Figure2_JCR.pdf, replace	
	
	
	
	**********************************
	***
	*** COMBINE FREQUENCIES
	***
	**********************************	
	
    clear all
	set more off
	
	*use first_components_annual.dta
	use Output/first_components_annual.dta
	
	*merge 1:1 year using first_components_quarterly.dta
	merge 1:1 year using Output/first_components_quarterly.dta
	drop _merge
	tsset year	
	
	drop if year<1967   
	
	* CEA chart
	
	egen mean_a_cea_6var = mean(a_f1_pcasecond_6var)
	egen var_a_cea_6var  = sd(a_f1_pcasecond_6var)
	
	egen mean_a_cea_8var = mean(a_f1_pcasecond_8var)
	egen var_a_cea_8var  = sd(a_f1_pcasecond_8var)
	
	egen mean_q_cea = mean(q_f1_pcasecond_cea_long)
	egen var_q_cea  = sd(q_f1_pcasecond_cea_long)
	
	replace a_f1_pcasecond_6var      = (a_f1_pcasecond_6var - mean_a_cea_6var)/var_a_cea_6var
	replace a_f1_pcasecond_8var      = (a_f1_pcasecond_8var - mean_a_cea_8var)/var_a_cea_8var
	replace q_f1_pcasecond_cea_long  = (q_f1_pcasecond_cea_long - mean_q_cea)/var_q_cea
	
	
	twoway (line  a_f1_pcasecond_6var        year, lwidth(thick)    lcolor(red) plotregion(color(white)) legend(region(lcolor(white)) col(3) lab(1 "Annual (5 var)") lab(2 "Annual (8 var)") lab(3 "Quarterly")))  ///
		   (line  a_f1_pcasecond_8var        year, lwidth(thin)     lcolor(red)) ///
		   (line  q_f1_pcasecond_cea_long    year, lwidth(medthick) lcolor(red) lpattern(longdash) plotregion(ilcolor(white)) graphregion(color(white)) bgcolor(white) xtitle("") ytitle("") xlabel(1970(10)2015)) 
		  
	graph save   Output/Figures_GPH/Figure_3/Figure3.gph, replace	
	graph export Output/Figures_PDF/Figure_3/Figure3.pdf, replace	
		   
	
	* COMBINED
	
	egen mean_a_f1_cf_pcasecond_8var = mean(a_f1_cf_pcasecond_8var)
	egen var_a_f1_cf_pcasecond_8var  = sd(a_f1_cf_pcasecond_8var)
	
	egen mean_a_f1_cos_pcasecond_8var = mean(a_f1_cos_pcasecond_8var)
	egen var_a_f1_cos_pcasecond_8var  = sd(a_f1_cos_pcasecond_8var)
	
	replace a_f1_cf_pcasecond_8var      = (a_f1_cf_pcasecond_8var - mean_a_f1_cf_pcasecond_8var)/var_a_f1_cf_pcasecond_8var
	replace a_f1_cos_pcasecond_8var     = (a_f1_cos_pcasecond_8var - mean_a_f1_cos_pcasecond_8var)/var_a_f1_cos_pcasecond_8var	
	
	twoway (line  a_f1_pcasecond_8var       year if year>=1977, lwidth(thick)    lcolor(navy) plotregion(color(white)) legend(region(lcolor(white)) col(3) lab(1 "Baseline (biweight)") lab(2 "CF filter") lab(3 "Cosine projections")))  ///
		   (line  a_f1_cf_pcasecond_8var    year if year>=1977, lwidth(thin)     lcolor(navy)) ///
		   (line  a_f1_cos_pcasecond_8var   year if year>=1977, lwidth(medthick) lcolor(navy) lpattern(longdash) plotregion(ilcolor(white)) graphregion(color(white)) bgcolor(white) xtitle("") ytitle("") xlabel(1970(10)2015)) 
		   
	graph save   Output/Figures_GPH/Figure_A2/FigureA2.gph, replace	
	graph export Output/Figures_PDF/Figure_A2/FigureA2.pdf, replace	
	
	
