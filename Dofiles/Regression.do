// This file saves the regression commands of CPS_Cleaned

ssc install ftools

clear
cd "C:\Users\theou\OneDrive\UW Madison\Spring 2022\Econ 580\Data\Scratch"
sysuse CPS_Cleaned

reghdfe hoursworking i_closed##i.hasSchoolAgeChild i_reopen##i.hasSchoolAgeChild covid_confirmed_ratio covid_deaths_ratio age nchild [pweight=wtfinl], absorb(county date_m occ2010 ind1950 race sex marst) vce(cluster county date_m) 

reghdfe hoursworking i_closed##i.hasSchoolAgeChild i_reopen##i.hasSchoolAgeChild i_closed##i.hasYoungChild i_reopen##i.hasYoungChild covid_confirmed_ratio covid_deaths_ratio age nchild [pweight=wtfinl], absorb(county date_m occ2010 ind1950 race sex marst) vce(cluster county date_m) 

reghdfe hoursworking i_closed##i.hasSchoolAgeChild i_reopen##i.hasSchoolAgeChild i_closed##i.hasYoungChild i_reopen##i.hasYoungChild j_closed##i.hasSchoolAgeChild j_reopen##i.hasSchoolAgeChild j_closed##i.hasYoungChild j_reopen##i.hasYoungChild covid_confirmed_ratio covid_deaths_ratio age nchild [pweight=wtfinl], absorb(county date_m occ2010 ind1950 race sex marst) vce(cluster county date_m) 

// Equation 4
reghdfe hoursworking i_closed##i.hasSchoolAgeChild i_reopen##i.hasSchoolAgeChild j_closed##i.hasSchoolAgeChild j_reopen##i.hasSchoolAgeChild covid_confirmed_ratio covid_deaths_ratio age nchild [pweight=wtfinl] if hasYoungChild != 1, absorb(county date_m occ2010 ind1950 race sex marst) vce(cluster county date_m) 

//Garcia's baseline model
reghdfe hoursworking i.hasSchoolAgeChild##c.share_all_closed_50 covid_confirmed_ratio covid_deaths_ratio age nchild, absorb(county date_m occ2010 ind1950 race sex marst) vce(cluster county date_m)


// Regression with teleworkability
cd ..
gen T = teleworkability
gen K = hasSchoolAgeChild
gen J = hasYoungChild 
gen S = share_all_closed_50 
gen C = share_closed_50 


reghdfe hoursworking i.K##c.S##c.T covid_confirmed_ratio covid_deaths_ratio age nchild ind1950 race sex marst, absorb(county date_m) vce(cluster county date_m)


outreg2 using "hoursworking_regression.doc", replace word 

reghdfe hoursworking i.K##c.S##c.T i.J##c.S##c.T covid_confirmed_ratio covid_deaths_ratio age nchild ind1950 race sex marst, absorb(county date_m ) vce(cluster county date_m)


outreg2 using "hoursworking_regression.doc", append word 

reghdfe hoursworking i.K##c.S##c.T i.J##c.S##c.T i.K##c.C##c.T i.J##c.C##c.T covid_confirmed_ratio covid_deaths_ratio age nchild ind1950 race sex marst, absorb(county date_m ) vce(cluster county date_m)

outreg2 using "hoursworking_regression.doc", append word 








// Females
reghdfe hoursworking i.K##c.S##c.T covid_confirmed_ratio covid_deaths_ratio age nchild, absorb(county date_m ind1950 race marst) vce(cluster county date_m) if sex == 0


outreg2 using "hoursworking_regression_female.doc", replace word label

reghdfe hoursworking i.K##c.S##c.T i.J##c.S##c.T covid_confirmed_ratio covid_deaths_ratio age nchild, absorb(county date_m ind1950 race marst) vce(cluster county date_m) if sex == 0


outreg2 using "hoursworking_regression_female.doc", append word label

reghdfe hoursworking i.K##c.S##c.T i.J##c.S##c.T i.K##c.C##c.T i.J##c.C##c.T covid_confirmed_ratio covid_deaths_ratio age nchild, absorb(county date_m ind1950 race marst) vce(cluster county date_m) if sex == 0

outreg2 using "hoursworking_regression_female.doc", append word label

reghdfe hoursworking i.K##c.S##c.T i.K##c.C##c.T covid_confirmed_ratio covid_deaths_ratio age nchild, absorb(county date_m ind1950 race marst) vce(cluster county date_m) if sex == 0

outreg2 using "hoursworking_regression_female.doc", append word label



reghdfe atwork i.K##c.S##c.T covid_confirmed_ratio covid_deaths_ratio age nchild, absorb(county date_m ind1950 race sex marst) vce(cluster county date_m)

outreg2 using "atwork_regression_female.doc", replace word label

reghdfe atwork i.K##c.S##c.T i.J##c.S##c.T covid_confirmed_ratio covid_deaths_ratio age nchild, absorb(county date_m ind1950 race sex marst) vce(cluster county date_m)


outreg2 using "atwork_regression_female.doc", append word label

reghdfe atwork i.K##c.S##c.T i.J##c.S##c.T i.K##c.C##c.T i.J##c.C##c.T covid_confirmed_ratio covid_deaths_ratio age nchild, absorb(county date_m ind1950 race sex marst) vce(cluster county date_m)

outreg2 using "atwork_regression_female.doc", append word label

reghdfe atwork i.K##c.S##c.T i.K##c.C##c.T covid_confirmed_ratio covid_deaths_ratio age nchild, absorb(county date_m ind1950 race sex marst) vce(cluster county date_m)

outreg2 using "atwork_regression_female.doc", append word label



//
keep if hasYoungChild == 0

reghdfe hoursworking i.K##c.S##c.T i.K##c.C##c.T covid_confirmed_ratio covid_deaths_ratio age nchild i.ind1950 i.race i.sex i.marst, absorb(county date_m) vce(cluster county date_m)

outreg2 using "hoursworking_regression.doc", append word 


