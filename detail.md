## Repository Structure

*The repository is structured as follows:*

- **\CPS_ASEC_Materials**
  - Contains the do-files to reproduce Table 7 and A1, and Figures 4, 5, A1, A3, and A4. Also contains the do-files to replicate the main data sets for the tables and figures, but none of the raw CPS or ASEC data are provided.
- **\Firms_90_10_GSS_Materials**
  - Contains the do-files to reproduce Table 8, and Figures 8 and 9. Note that only Table 8 can be completely replicated, as the underlying General Social Survey (GSS) data for Figures 8 and 9 are not provided.
- **\NLS_Materials**
  - Contains the do-files to reproduce Tables 5, 6, and 7. Also contains the do-files for replicating the three main National Longitudinal Survey data sets, but the raw NLS data are not provided.
- **\PCA_Materials**
  - Contains the do-files to reproduce Tables 1, 2, 3, A2, A3, A4, A5, and Figures 1, 2, 3, and A2. These do-files call data created by the Matlab code in the **Replicate_MullerWatsonTrends** folder.
- **\PSID_CPS_Materials**
  - Contains the do-files that reproduce Tables 2, 4, 7, A6, and Figures 6, 7, 10, 12, and A5. The raw CPS data can be obtained from IPUMS, or may be available upon request.

## CPS_ASEC_Materials

*Note that none of the data used in these do-files are provided (other than **j2jqwi.csv**)*

- **Data set construction**
  - **annual-data.do** – Creates annual-level data set for time series analysis.
  - **flows-monthly.do** – merges in flows data from Elsby, Michales, and Ratner with most recent data as provided by the BLS.
  - **match_extract.do** – for extracting variables from raw CPS data.
  - **match_flows-age-sex.do** – constructs the annual flows by age and sex data set.
  - **match_merge.do** – takes extracted CPS data from **match_extract.do**.
  - **jobchange-migrate-decomp.do** – Creates job changing and migration rates (**empchange-decomp.dta** and **migstate-decomp.dta**) using March CPS data and uses these data to run cell-level regressions for the decompositions shown in Figure 5 and Figure A4.
  - **transitions-by-group.do** – creates **transitions-by-group.dta**.
  - **Estar-FE-decomp.do** – Creates E* rates (**Estar-decomp.dta**) using matched CPS data (not provided) and uses these data to run cell-level regressions for the decompositions shown in Figure 5 and Figure A4.
  - **NE-FE-decomp.do** – Creates NE rates (**NE-decomp.dta**) using matched CPS data and uses these data to run cell-level regressions for the decompositions shown in Figure 5 and Figure A4.
  - **starE-FE-decomp.do** – creates * E rates (**starE-decomp.dta**) using matched CPS data and uses these data to run cell-level regressions for the decompositions shown in Figure 5 and Figure A4.
  - **UE-FE-decomp.do** – creates UE rates (**UE-decomp.dta**) using matched CPS data and uses these data to run cell-level regressions for the decompositions shown in Figure 5 and Figure A4.
  - **unicon-collapse.do** – collapses Unicon migration data.
  - **unicon-collapse-byagesex.do** - collapses Unicon migration data by age and sex.
  - **j2jgqwi.do** – imports the **j2jqwi.csv** and saves it as **j2jaqwi.dta**.

- **Figure 4 and A3**
  - **fig-4.do** – uses **transitions-by-group.dta** to generate Figures 4 and A3.

- **Figure 5 and A4**
  - **fig-5.do** – uses **'v'-decomp.dta**, created by **'v'-FE-decomp.do**, where 'v' is starE, Estar, UE, NE, migstate, and empchange, to generate generates Figures 5 and A4.

- **Figure A1**
  - **fig-A1.do** – generates Figure A1. The following data sets are called:
    - **EE-fleishman-fallick.dta** – EE transition rate as provided by the Federal Reserve website for Fleischman and Fallick 2004.
    - **pop-stocks.dta** – BLS data on the level of employment.
    - **jolts.dta** – JOLTS data from the BLS.
    - **flows-monthly.dta** – monthly flows data 
    - **j2jqwi.dta** – job-to-job flows from the QWI. CSV version converted to DTA by **j2jgqwi.do**.
    - **unicon-collapse.dta** – migration and firm changing rates from Unicon.

- **Table 7. Nested Tests of Contracting Model**
  - **table-7-cps.do** – uses CPI data from the CPS (**cpi-month.dta**), the male unemployment rate from the CPS (**UR-male.dta**), and then reads in CPS supplement data (**monYY.dta**) as provided by Unicon to replicate the CPS results (columns 3 and 4) from Table 7. Results are saved in table-7-cps.dta.

- **Table A.1: Contribution of changing age-sex shares to changes in measures of labor market fluidity**
  - **table-A1.do** – uses **flows-annual-age-sex.dta** and **unicon-collapse-byagesex.dta** to replicate Table A1, rows 1-3 and row 5 of each panel. Results are saved in **table-A1.dta**. 

## Firms_90_10_GSS_Materials

*Note that none of the raw GSS data are provided.*

- **Figures 8 and 9**
  - **socialcapital.do** and **stateregs_gss.do** use restricted General Social Survey data. **socialcapital.do** creates Figure 8. **stateregs_gss.do** creates Figure 9. Note that these files will not run, but are included for reference. **socialcaptial.do** uses the Sensitive GSS data (obtainable from NORC on CD) to create state level measures of trust and memberships. These are used in **stateregs_gss.do**. To obtain data to replicate these results, apply for access to the Sensitive GSS with state identifiers from NORC.

- **Table 8. Geographic Dimension of Rising Firm-Level Inequality**
  - **table8.do** – uses **90_10_percent_dissemination_csv.csv**, a BLS special tabulation, to create Table 8. The original 90_10 file obtained from BLS is included in Excel97 format. This do-file also creates the graphs **ratio_all.gph**, **ratio_ne_midwest.gph**, and **ratio_west.gph**, none of which are in the published paper. It also creates the data set **div_90_10_percent_compensationratio.dta**.

## NLS_Materials

*Note that none of the raw NLS data are provided. The do-files under data sets take minimally processed data from the NLS Investigator website and create the **xxxtenure.dta** data sets, primarily by constructing measures of industry, occupation, and job tenure. The final NLS data sets used to construct the tables and figures are provided.*

- **Data set Construction**
  - **make_tenurevarsYM.do** – uses raw NLS YM data to construct the final NLSYM data set **nlsym_tenure.dta**. 
  - **make_tenurevars79.do** – uses raw NLSY 1979 data, spanning 1979 to 1994, to construct the final 1979 NLSY data set **nlsy79tenure.dta**.
  - **make_tenurevars97.dta** – uses raw NLSY 1997 data, spanning 1997 to 2013, to construct the final 1997 NLSY data set **nlsy97tenure2013.dta**.

- **Table 5. Average Hourly Wage for Jobs Held for Less than One Year for Men Ages 22-33**
  - **table5_ym.do** – merges **nlsym_tenure.dta** and **usurate16up.dta** and creates the coefficients in the left-most column (NLSM) of Table 5.
  - **table5_79.do** – merges **nlsy79tenure.dta** and **usurate16up.dta** and creates the coefficients in the middle column (NLSY79) of Table 5.
  - **table5_79.do** – merges **nlsy97tenure2013.dta** and **usurate16up.dta** and creates the coefficients in the right-most column (NLSY97) of Table 5.

- **Table 6. Implied Returns to a Third Year of Employer Tenure for Men Ages 22-23**
  - **table6_ym.do** – uses **nlsym_tenure.dta** to create the implied returns in the left-most column (NLSM) of Table 6.
  - **table6_79.do** – uses **nlsymtenure79.dta** to create the implied returns in the middle column (NLSY79) in Table 6.
  - **table6_97.do** – uses **nlsy97tenure2013.dta** to create the implied returns in the right-most column (NLSY97) in Table 6.

- **Table 7. Nested Tests of Contracting Models**
  - **table7_79.do** – merges **nlsy79tenure.dta** and **usurate16up.dta** and creates the coefficients in the NLSY79 column of Table 7.
  - **table7_97.do** – merges **nlsy97tenure2013.dta** and **usurate16up.dta** and creates the coefficients in the right-most column (NLSY97) of Table 7. The regression output is saved in bd1997.doc. **These results do not match published but do match earlier log file.**

## PSID_CPS_Materials 

*Note that none of the raw CPS data set can be downloaded from IPUMS, or may be available upon request.*

- **Data set Construction**
  - **cpscovariates.do** – cleans the raw CPS data set (**cps_00026.dta**) and merges with **bds_e_st_releast.csv**, state-level establishment data from the Census Bureau’s Business Dynamics Statistics program (1977-2013), to create **cpscovariates.dta**. It also creates **ipums3565.dta**.

- **Table 2, 7, & A5**
  - **startwage.do** – uses **J206031.txt**, raw PSID data, to construct column 1 **(Not matched in paper but matched with original log file)** and 2 in Table 7. It also creates **startwagepsid.gph**, Appendix Figure A5. A CSV file with this data is also constructed, called **startwagepsid.csv**. The following data sets are used in this do-file:
    - **urateus.dta** – US unemployment rate data.
    - **urateusyb.dta** – US unemployment rate data.
    - **urateusyear.dta** – US unemployment rate data.

- **Tables 4 & A6; Figures 6, 10, & 12**
  - **stateregs.do** – merges state-year labor market flows with covariates from the CPS, creates state-trends in labor market fluidity, runs the PCA to combine the trends, and performs most of the analysis reported in Section 3. **statefig.gph** is Figure 6. **regfig.gph** is Figure 10. **hrfig.gph** is Figure 12. Table 4 and Table A6 **(Matched other than column 6, but original log file matches)** are also created.  It also calculates the correlations of declines in fluidity, and constructs the data sets **wharton.dta**, **union.dta**, **statepop6010.dta**, and **stateregs.dta**. The following data sets are used in this do-file:
    - **State_Union_Membership_Density_1964-2015.csv** – state-level union membership data.
    - **WHARTON LAND USE REGULATION DATA_1_24_2008.dta** – data from the Wharton Land Use Survey.
    - **stateur.dta** – state-level unemployment data from the BLS.
    - **state-level-data.dta** – Labor market flows data from Unicon.
    - **state_hr_rate_Stata13.dta** – state-level Society for Human Resource Management membership data from 1998 to 2013. These data are not provided.
    - **cpscovariates.dta** – data set constructed above.

- **Figure 7**
  - **stateregs3564.do** – merges files to create **agecorr.gph**, Figure 7, and a CSV file **agefig.csv**. The following data sets are called:
    - **state-age-level-data.dta** – Labor market flows data from Unicon.
    - **ipums3564.dta** – State-level migrant and employment data from IPUMS.
    - **cpscovariates.dta** – Data set constructed above.
    - **union.dta** – State-level union data.
    - **stateur.dta** – State-level unemployment data.

## PCA_Materials

*Note that the raw data used to produce the data sets referenced in the Matlab code are not provided. This does not prevent the code for replicating the tables or figures.*

- **Tables 1, 2, 3, A2, A3, A4, & A5; Figure 1 & 2**
  - **PCA_timeseries.do** – uses **annual_series.dta** and **quarterly_series.dta** to construct Table 1, Table 2, Table 3, Table A2, Table A3, Table A4, Table A5, Figure 1, and Figure 2. It also creates the data sets **first_components_annual_transitory.dta**, **first_components_annual.dta**, **first_components_quarterly.dta**, with the latter two used to construct Figure 3 and Figure A2.
  - **Replicate_MullerWatsonTrends Folder** – This code runs to create the Muller & Watson trends. The main output is **labor_series.xslx**, which has two tabs (quarterly and yearly) that contain the same data as in **annual_series.dta** and **quarterly_series.dta**. To run the code in Matlab, execute the following commands:
	
	><p>p = ‘path to replication directory’<br>
	>addpath(genpath(p));<br>
	>cd(p) ;<br>
	>labor;</p>
	
	The plots will be saved to the “fig” subdirectory and the text output will be saved to the “out” subdirectory. Note that the code doesn’t run on our default Matlab 2010 so you’ll need to run it with a newer version of Matlab. The code was run using Matlab 2013a, and replicated in Matlab R2019a.
