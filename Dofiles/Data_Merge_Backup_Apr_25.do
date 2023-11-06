// This do-file merges data of CPS, School Closure, and Childcare Closure samples.

clear // Clearas the existing data
cd "C:\Users\theou\Documents\School Work\UW Madison\Spring 2022\Econ 580\Data\Scratch"


/*
	This section cleans and sorts the School Closure data by county, year, month
*/

sysuse schools_county
recast int year
recast byte month
generate time = (year-2020)*12+month // set t=1 at Jan 2020
rename countyfips3 county // countyfips3 is the code consistent with county in CPS


duplicates tag county year month, generate(id_duplicates)
drop if id_duplicates != 0 // Drops the duplicates
/*
generate schools_open = 1 // Dummy for having schools staying open
generate schools_closed = 0 // Dummy for having schools closed
generate schools_reopened = 0 // Dummy for having schools reopened
replace schools_open = 0 if ()
*/
sort county time
save schools_county_sorted, replace

clear


/*
	This section cleans and sorts the Childcare Closure data by county, year, month
*/

sysuse care_county
recast int year
recast byte month
generate time = (year-2020)*12+month // set t=1 at Jan 2020
rename countyfips3 county // countyfips3 is the code consistent with county in CPS

duplicates tag county year month, generate(id_duplicates)
drop if id_duplicates != 0 // Drops the duplicates

sort county time
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

keep if age >= 21 // Keep obs with age above or equal to 21 only
drop if year != 2020 & year != 2021 // Keep 2020 and 2021 data only
count
drop if county == 0 // Keep obs with county idenfiers only
count

generate time = (year-2020)*12+month // set t=1 at Jan 2020

sort county time

merge m:1 county time using schools_county_sorted, gen(_merge1) // merge schhol closure
merge m:1 county time month using care_county_sorted, gen(_merge2) // merge childcare
merge m:1 county using time_series_covid19_confirmed_US_county_sorted, keepusing(county province_state country_region v33 v62 v93 v123 v154 v184 v215 v246 v276 v307 v337 v368 v399 v427 v458 v488 v519 v549 v580 v611 v641 v672 v701) gen(_merge3) // merge covid cases
merge m:1 county using time_series_covid19_deaths_US_county_sorted, keepusing(county province_state country_region v34 v63 v94 v124 v155 v185 v216 v247 v277 v308 v338 v369 v400 v428 v459 v489 v520 v550 v581 v612 v642 v673 v702) gen(_merge4) // merge covid deaths

drop if _merge1+_merge2+_merge3+_merge4 != 12 // Remove all unmatched data

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


save CPS_Cleaned, replace
