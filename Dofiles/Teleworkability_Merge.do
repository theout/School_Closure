*** This do-file merges CPS data with teleworkability data, and conduct analysis on occupation outcomes
ssc install outreg2


// Import the teleworkability crosswalk data
cd ..

clear
import excel ".\Raw Data\teleworkability_crosswalk.xlsx", sheet("Teleworkability") firstrow case(lower)
destring occ2010, replace
save ".\Raw Data\teleworkability_crosswalk.dta", replace

clear
sysuse .\Scratch\CPS_Cleaned.dta

// Drop the unidentified occupations
drop if occ2010 == 9999

// Merge the teleworkability data
merge m:1 occ2010 using ".\Raw Data\teleworkability_crosswalk.dta"
keep if _merge==3

// Remove the occupations where teleworkability is not available
drop if teleworkability == -1

save ".\Scratch\CPS_teleworkability.dta", replace


// Times Series
xtset cpsidp date_m
sort cpsidp date_m

by cpsidp: gen teleworkability_lead1 = F.teleworkability
by cpsidp: gen teleworkability_lead2 = F2.teleworkability
by cpsidp: gen teleworkability_lead3 = F3.teleworkability
by cpsidp: gen occupation_lead1 = F.occ2010
by cpsidp: gen occupation_lead2 = F2.occ2010
by cpsidp: gen occupation_lead3 = F3.occ2010

by cpsidp: gen teleworkability_change1 = teleworkability_lead1 - teleworkability
by cpsidp: gen teleworkability_change2 = teleworkability_lead2 - teleworkability
by cpsidp: gen teleworkability_change12 = teleworkability_lead12 - teleworkability
by cpsidp: gen occupation_change12 = (occupation_lead12 != occ2010)


// Regressions on change in occupation and change in teleworkability
keep if hasYoungChild == 0

reghdfe teleworkability_change1 i.i_closed_flag##i.hasSchoolAgeChild i.i_reopen_flag##i.hasSchoolAgeChild covid_confirmed_ratio covid_deaths_ratio age nchild, absorb(i.county i.ind1950 i.race i.sex i.marst) vce(cluster i.county i.date_m)

outreg2 using "Ethan_teleworkability_regression.doc", replace word


xtset cpsidp date_m
sort cpsidp date_m

by cpsidp: gen teleworkability_lead1 = F.teleworkability
by cpsidp: gen teleworkability_lead2 = F2.teleworkability
by cpsidp: gen teleworkability_lead3 = F3.teleworkability
by cpsidp: gen teleworkability_lead12 = F12.teleworkability
by cpsidp: gen occupation_lead1 = F.occ2010
by cpsidp: gen occupation_lead2 = F2.occ2010
by cpsidp: gen occupation_lead3 = F3.occ2010
by cpsidp: gen occupation_lead12 = F12.occ2010

by cpsidp: gen teleworkability_change1 = teleworkability_lead1 - teleworkability
by cpsidp: gen teleworkability_change2 = teleworkability_lead2 - teleworkability
by cpsidp: gen teleworkability_change12 = teleworkability_lead12 - teleworkability
by cpsidp: gen occupation_change12 = (occupation_lead12 != occ2010)


// Regressions
keep if hasYoungChild == 0

reghdfe teleworkability_change1 i.i_closed_flag##i.hasSchoolAgeChild i.i_reopen_flag##i.hasSchoolAgeChild covid_confirmed_ratio covid_deaths_ratio age nchild, absorb(i.county i.ind1950 i.race i.sex i.marst) vce(cluster i.county i.date_m)

outreg2 using "Ethan_teleworkability_regression.doc", replace word