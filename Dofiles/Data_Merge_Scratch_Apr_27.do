// This do-file merges data of CPS, School Closure, and Childcare Closure samples.

clear // Clearas the existing data
cd "C:\Users\theou\Documents\School Work\UW Madison\Spring 2022\Econ 580\Data\Scratch"


/*
	This section cleans and sorts the School Closure data by county, year, month
*/

sysuse schools_county
recast int year
recast byte month

rename countyfips3 county // countyfips3 is the code consistent with county in CPS


duplicates tag county year month, generate(id_duplicates)
drop if id_duplicates != 0 // Drops the duplicates
/*
generate schools_open = 1 // Dummy for having schools staying open
generate schools_closed = 0 // Dummy for having schools closed
generate schools_reopened = 0 // Dummy for having schools reopened
replace schools_open = 0 if ()
*/
sort county year month
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

sort county year month

merge m:1 county year month using schools_county_sorted, gen(_merge1) // merge schhol closure
merge m:1 county year month using care_county_sorted, gen(_merge2) // merge childcare
merge m:1 county using time_series_covid19_confirmed_US_county_sorted, keepusing(county province_state country_region v33 v62 v93 v123 v154 v184 v215 v246 v276 v307 v337 v368 v399 v427 v458 v488 v519 v549 v580 v611 v641 v672 v701) gen(_merge3) // merge covid cases
merge m:1 county using time_series_covid19_deaths_US_county_sorted, keepusing(county province_state country_region v34 v63 v94 v124 v155 v185 v216 v247 v277 v308 v338 v369 v400 v428 v459 v489 v520 v550 v581 v612 v642 v673 v702) gen(_merge4) // merge covid deaths
