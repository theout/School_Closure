// This file saves the regression commands of CPS_Cleaned

clear // Clearas the existing data
cd "C:\Users\theou\Documents\School Work\UW Madison\Spring 2022\Econ 580\Data\Scratch"
sysuse CPS_Cleaned

reghdfe hoursworking i_closed##i.hasSchoolAgeChild i_reopen##i.hasSchoolAgeChild covid_confirmed_ratio covid_deaths_ratio age nchild [pweight=wtfinl], absorb(county date_m occ2010 ind1950 race sex marst) vce(cluster county date_m) 

reghdfe hoursworking i_closed##i.hasSchoolAgeChild i_reopen##i.hasSchoolAgeChild i_closed##i.hasYoungChild i_reopen##i.hasYoungChild covid_confirmed_ratio covid_deaths_ratio age nchild [pweight=wtfinl], absorb(county date_m occ2010 ind1950 race sex marst) vce(cluster county date_m) 

reghdfe hoursworking i_closed##i.hasSchoolAgeChild i_reopen##i.hasSchoolAgeChild i_closed##i.hasYoungChild i_reopen##i.hasYoungChild j_closed##i.hasSchoolAgeChild j_reopen##i.hasSchoolAgeChild j_closed##i.hasYoungChild j_reopen##i.hasYoungChild covid_confirmed_ratio covid_deaths_ratio age nchild [pweight=wtfinl], absorb(county date_m occ2010 ind1950 race sex marst) vce(cluster county date_m) 

// Equation 4
reghdfe hoursworking i_closed##i.hasSchoolAgeChild i_reopen##i.hasSchoolAgeChild j_closed##i.hasSchoolAgeChild j_reopen##i.hasSchoolAgeChild covid_confirmed_ratio covid_deaths_ratio age nchild [pweight=wtfinl] if hasYoungChild != 1, absorb(county date_m occ2010 ind1950 race sex marst) vce(cluster county date_m) 

//Garcia's baseline model
reghdfe hoursworking i.hasSchoolAgeChild##c.share_all_closed_50 covid_confirmed_ratio covid_deaths_ratio age nchild, absorb(county date_m occ2010 ind1950 race sex marst) vce(cluster county date_m)