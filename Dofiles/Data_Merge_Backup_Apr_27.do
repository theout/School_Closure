// This do-file merges data of CPS, School Closure, and Childcare Closure samples.

clear // Clearas the existing data
cd "C:\Users\theou\Documents\School Work\UW Madison\Spring 2022\Econ 580\Data\Scratch"

/*
	This section cleans the Population dataset
*/
sysuse Population_2020-2021
drop if county == 0

replace county = state*1000 + county

duplicates tag county, generate(id_duplicates)
drop if id_duplicates != 0 // Drops the duplicates

sort county

save Population_2020-2021_sorted, replace

clear

/*
	This section cleans and sorts the School Closure data by county, year, month
*/

sysuse schools_county
recast int year
recast byte month

rename countyfips3 county // countyfips3 is the code consistent with county in CPS


duplicates tag county year month, generate(id_duplicates)
drop if id_duplicates != 0 // Drops the duplicates

sort county year month


/*
	This section converts the dataset to panel data and generates the closed dummy with a cutoff of 50% and the reopened dummy with a cutoff of 10%.
*/
gen date_m = ym(year, month)
format date_m %tm
xtset county date_m // Converts to a panel data by countyfips3

gen i_closed = (share_all_closed_50 > .50) // Locates the months the county closed
replace i_closed = 1 if i_closed == 0 & l.i_closed == 1 

gen i_reopen = ( share_all_closed_50 < 0.1 & l.i_closed == 1) // Locates the months when the county reopened
replace i_reopen = 1 if i_reopen == 0 & l.i_reopen == 1

replace i_closed = 0 if i_reopen == 1


save schools_county_sorted, replace

clear


/*
	This section cleans and sorts the Childcare Closure data by county, year, month
*/

sysuse care_county
recast int year
recast byte month

rename countyfips3 county // countyfips3 is the code consistent with county in CPS

duplicates tag county year month, generate(id_duplicates)
drop if id_duplicates != 0 // Drops the duplicates

sort county year month

/*
	This section converts the dataset to panel data and generates the closed dummy with a cutoff of 50% and the reopened dummy with a cutoff of 10%.
*/
gen date_m = ym(year, month)
format date_m %tm
xtset county date_m // Converts to a panel data by countyfips3

gen j_closed = (share_closed_50 > .50) // Locates the months the county closed
replace j_closed = 1 if j_closed == 0 & l.j_closed == 1 

gen j_reopen = ( share_closed_50 < 0.1 & l.j_closed == 1) // Locates the months when the county reopened
replace j_reopen = 1 if j_reopen == 0 & l.j_reopen == 1

replace j_closed = 0 if j_reopen == 1


save care_county_sorted, replace

clear


/*
	This section cleans the Covid-19 Cases Data and sorts it by county, year, month.
*/

sysuse time_series_covid19_confirmed_US_county
rename fips county // fips is the county fips code

duplicates tag county, generate(id_duplicates)
drop if id_duplicates != 0 // Drops the duplicates

sort county
save time_series_covid19_confirmed_US_county_sorted, replace

clear


/*
	This section cleans the Covid-19 Deaths Data and sorts it by county, year, month.
*/

sysuse time_series_covid19_deaths_US_county
rename fips county // fips is the county fips code

duplicates tag county, generate(id_duplicates)
drop if id_duplicates != 0 // Drops the duplicates

sort county
save time_series_covid19_deaths_US_county_sorted, replace

clear


/*
	This section sorts the CPS data and merges it with the samples saved above
*/
sysuse CPS_1

drop if age < 21
drop if year != 2020 & year != 2021 // Keep 2020 and 2021 data only
count
drop if county == 0 // Keep obs with county idenfiers only
count

sort county year month

merge m:1 county year month using schools_county_sorted, gen(_merge1) // merge schhol closure
merge m:1 county year month using care_county_sorted, gen(_merge2) // merge childcare
merge m:1 county using time_series_covid19_confirmed_US_county_sorted, keepusing(county province_state country_region v33 v62 v93 v123 v154 v184 v215 v246 v276 v307 v337 v368 v399 v427 v458 v488 v519 v549 v580 v611 v641 v672 v701) gen(_merge3) // merge covid cases
merge m:1 county using time_series_covid19_deaths_US_county_sorted, keepusing(county province_state country_region v34 v63 v94 v124 v155 v185 v216 v247 v277 v308 v338 v369 v400 v428 v459 v489 v520 v550 v581 v612 v642 v673 v702) gen(_merge4) // merge covid deaths
merge m:1 county using Population_2020-2021_sorted, keepusing(county popestimate2020 popestimate2021) gen(_merge5) // merge county populations

drop if _merge1+_merge2+_merge3+_merge4+_merge5 != 15 // Remove all unmatched data

// It seems like most unmatched obs are due to missing county code in the CPS sample.



/* 
This section cleans the covid cases and deaths data.
*/

// generate a variable to store confirmed covid cases
generate covid_confirmed = . 
replace covid_confirmed = 0 if year == 2020 & month == 1
replace covid_confirmed = v33 if year == 2020 & month == 2
replace covid_confirmed = v62 if year == 2020 & month == 3
replace covid_confirmed = v93 if year == 2020 & month == 4
replace covid_confirmed = v123 if year == 2020 & month == 5
replace covid_confirmed = v154 if year == 2020 & month == 6
replace covid_confirmed = v184 if year == 2020 & month == 7
replace covid_confirmed = v215 if year == 2020 & month == 8
replace covid_confirmed = v246 if year == 2020 & month == 9
replace covid_confirmed = v276 if year == 2020 & month == 10
replace covid_confirmed = v307 if year == 2020 & month == 11
replace covid_confirmed = v337 if year == 2020 & month == 12
replace covid_confirmed = v368 if year == 2021 & month == 1
replace covid_confirmed = v399 if year == 2021 & month == 2
replace covid_confirmed = v427 if year == 2021 & month == 3
replace covid_confirmed = v458 if year == 2021 & month == 4
replace covid_confirmed = v488 if year == 2021 & month == 5
replace covid_confirmed = v519 if year == 2021 & month == 6
replace covid_confirmed = v549 if year == 2021 & month == 7
replace covid_confirmed = v580 if year == 2021 & month == 8
replace covid_confirmed = v611 if year == 2021 & month == 9
replace covid_confirmed = v641 if year == 2021 & month == 10
replace covid_confirmed = v672 if year == 2021 & month == 11
replace covid_confirmed = v701 if year == 2021 & month == 12

// generate a variable to store covid deaths
generate covid_deaths = . 
replace covid_deaths = 0 if year == 2020 & month == 1
replace covid_deaths = v34 if year == 2020 & month == 2
replace covid_deaths = v63 if year == 2020 & month == 3
replace covid_deaths = v94 if year == 2020 & month == 4
replace covid_deaths = v124 if year == 2020 & month == 5
replace covid_deaths = v155 if year == 2020 & month == 6
replace covid_deaths = v185 if year == 2020 & month == 7
replace covid_deaths = v216 if year == 2020 & month == 8
replace covid_deaths = v247 if year == 2020 & month == 9
replace covid_deaths = v277 if year == 2020 & month == 10
replace covid_deaths = v308 if year == 2020 & month == 11
replace covid_deaths = v338 if year == 2020 & month == 12
replace covid_deaths = v369 if year == 2021 & month == 1
replace covid_deaths = v400 if year == 2021 & month == 2
replace covid_deaths = v428 if year == 2021 & month == 3
replace covid_deaths = v459 if year == 2021 & month == 4
replace covid_deaths = v489 if year == 2021 & month == 5
replace covid_deaths = v520 if year == 2021 & month == 6
replace covid_deaths = v550 if year == 2021 & month == 7
replace covid_deaths = v581 if year == 2021 & month == 8
replace covid_deaths = v612 if year == 2021 & month == 9
replace covid_deaths = v642 if year == 2021 & month == 10
replace covid_deaths = v673 if year == 2021 & month == 11
replace covid_deaths = v702 if year == 2021 & month == 12

// removes all the 12th-day-covid-variables
drop v33 v62 v93 v123 v154 v184 v215 v246 v276 v307 v337 v368 v399 v427 v458 v488 v519 v549 v580 v611 v641 v672 v701 v34 v63 v94 v124 v155 v185 v216 v247 v277 v308 v338 v369 v400 v428 v459 v489 v520 v550 v581 v612 v642 v673 v702


/* 
	This section cleans the merged CPS data
*/

// Creates the covid confirmed and deaths per 100,000 population
gen covid_confirmed_ratio = 0
replace covid_confirmed_ratio = covid_confirmed/popestimate2020*100000 if year == 2020
replace covid_confirmed_ratio = covid_confirmed/popestimate2021*100000 if year == 2021
gen covid_deaths_ratio = 0
replace covid_deaths_ratio = covid_deaths/popestimate2020*100000 if year == 2020
replace covid_deaths_ratio = covid_deaths/popestimate2021*100000 if year == 2021

gen i_YoungChild = (yngch < 5) // Generates havingYoungChild dummy
gen i_SchoolChild = ((yngch >= 5 & yngch < 18) | (eldch >= 5 & eldch <18)) // Generates havingSchoolAgeChild dummy

gen time = (year-2020)*12+month

gen i_closedXschoolChild = i_closed*i_SchoolChild
gen i_reopenXschoolChild = i_reopen*i_SchoolChild
gen i_closedXyoungChild = i_closed*i_YoungChild
gen i_reopenXyoungChild = i_reopen*i_YoungChild

gen j_closedXschoolChild = j_closed*i_SchoolChild
gen j_reopenXschoolChild = j_reopen*i_SchoolChild
gen j_closedXyoungChild = j_closed*i_YoungChild
gen j_reopenXyoungChild = j_reopen*i_YoungChild

xtset cpsidp date_m

save CPS_Cleaned, replace
